//
//  FirestoreService.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/8/25.
//
import Foundation
import FirebaseFirestore

final class FirestoreService {
    static let shared = FirestoreService()
    private init() {}
    private let db = Firestore.firestore()

    // MARK: Path helpers (exactly your schema)
    private func teamRef(_ teamId: String) -> DocumentReference {
        db.collection("teams").document(teamId)
    }
    private func coachRef(teamId: String, coachId: String) -> DocumentReference {
        teamRef(teamId).collection("coach").document(coachId)
    }
    private func playerRef(teamId: String, playerId: String) -> DocumentReference {
        teamRef(teamId).collection("players").document(playerId)
    }
    private func sessionsRef(teamId: String, playerId: String) -> CollectionReference {
        playerRef(teamId: teamId, playerId: playerId).collection("sessions")
    }
    private func summariesRef(teamId: String, playerId: String) -> CollectionReference {
        playerRef(teamId: teamId, playerId: playerId).collection("summaries")
    }
    private func monthlySummariesRef(teamId: String, playerId: String) -> CollectionReference {
        playerRef(teamId: teamId, playerId: playerId).collection("monthly_summaries")
    }
    private func heatmapRef(teamId: String, playerId: String) -> CollectionReference {
        playerRef(teamId: teamId, playerId: playerId).collection("heatmap")
    }
    private func analyticsRef(teamId: String) -> DocumentReference {
        db.collection("analytics").document(teamId)
    }

    // MARK: Teams
    func createTeam(_ team: TeamModel) async throws {
        try teamRef(team.team_id).setData(from: team)
    }

    func upsertCoach(teamId: String, coach: CoachProfile) async throws {
        try coachRef(teamId: teamId, coachId: coach.coach_id).setData(from: coach, merge: true)
    }

    // MARK: Players
    func upsertPlayer(teamId: String, player: PlayerModel) async throws {
        try playerRef(teamId: teamId, playerId: player.player_id).setData(from: player, merge: true)
    }

    // MARK: Sessions (AI/metrics-ready)
    func addSession(teamId: String, playerId: String, session: SessionModel) async throws {
        try sessionsRef(teamId: teamId, playerId: playerId).document(session.session_id).setData(from: session)
        // Example: increment player’s total_sessions
        try await playerRef(teamId: teamId, playerId: playerId).updateData([
            "total_sessions": FieldValue.increment(Int64(1)),
            "updated_at": Timestamp(date: Date())
        ])
    }

    func getSessions(teamId: String, playerId: String) async throws -> [SessionModel] {
        let snap = try await sessionsRef(teamId: teamId, playerId: playerId)
            .order(by: "session_date", descending: true)
            .getDocuments()
        return snap.documents.compactMap { try? $0.data(as: SessionModel.self) }
    }

    func updateSessionAdvice(teamId: String, playerId: String, sessionId: String, advice: String, confidence: Double?) async throws {
        var data: [String: Any] = ["generated_advice": advice]
        if let c = confidence { data["ai_confidence"] = c }
        try await sessionsRef(teamId: teamId, playerId: playerId).document(sessionId).updateData(data)
    }

    // MARK: Summaries & Heatmap
    func setDailySummary(teamId: String, playerId: String, summary: SummaryModel) async throws {
        try summariesRef(teamId: teamId, playerId: playerId).document(summary.summary_id).setData(from: summary)
    }

    func setMonthlySummary(teamId: String, playerId: String, month: MonthlySummaryModel) async throws {
        try monthlySummariesRef(teamId: teamId, playerId: playerId).document(month.month_id).setData(from: month)
    }

    func setHeatmap(teamId: String, playerId: String, map: HeatmapModel) async throws {
        try heatmapRef(teamId: teamId, playerId: playerId).document(map.heatmap_id).setData(from: map)
    }

    // MARK: Analytics
    func getTeamAnalytics(teamId: String) async throws -> TeamAnalyticsModel? {
        let doc = try await analyticsRef(teamId: teamId).getDocument()
        return try? doc.data(as: TeamAnalyticsModel.self)
    }

    func setTeamAnalytics(_ analytics: TeamAnalyticsModel) async throws {
        try analyticsRef(teamId: analytics.team_id).setData(from: analytics)
    }
}
