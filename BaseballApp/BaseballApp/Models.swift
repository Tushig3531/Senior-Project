//
//  Models.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/8/25.
//
// Models.swift
import Foundation

// /users/{uid}
struct UserModel: Identifiable, Codable {
    var id: String { uid }
    let uid: String
    let username: String
    let name: String
    let email: String
    let role: String            // coach or player
    let team_id: String         // keep "" if unknown yet
    let joined_at: Date
    let profile_url: String?
    let active: Bool
}

// /teams/{teamId}
struct TeamModel: Identifiable, Codable {
    var id: String { team_id }
    let team_id: String
    let team_name: String
    let coach_id: String        // users/{uid}
    let created_at: Date
    let description: String
    let is_active: Bool
    let subscription_tier: String   // free or paid
    let video_retention_days: Int
}

// /teams/{teamId}/coach/{coachId}
struct CoachProfile: Identifiable, Codable {
    var id: String { coach_id }
    let coach_id: String
    let username: String
    let name: String
    let email: String
    let experience_years: Int
    let joined_at: Date
    let profile_img_url: String?
}

// /teams/{teamId}/players/{playerId}
struct PlayerModel: Identifiable, Codable {
    var id: String { player_id }
    let player_id: String       // equals users/{uid} of that player
    let username: String
    let name: String
    let email: String
    let joined_at: Date
    let avg_accuracy: Double
    let avg_release_angle: Double
    let coach_advice: String
    let photo_url: String?
    let active: Bool
    let total_sessions: Int
    let updated_at: Date
}

// /teams/{teamId}/players/{playerId}/sessions/{sessionId}
struct SessionModel: Identifiable, Codable {
    var id: String { session_id }
    let session_id: String
    let session_date: Date
    let video_url: String?
    let release_angle: Double?
    let landing_x: Double?
    let landing_y: Double?
    let target_hit: Bool?
    let accuracy_score: Double?
    let consistency_index: Double?
    let ai_confidence: Double?
    let generated_advice: String?
    let created_at: Date
}

// /teams/{teamId}/players/{playerId}/summaries/{summaryId}
struct SummaryModel: Identifiable, Codable {
    var id: String { summary_id }
    let summary_id: String
    let session_date: Date
    let release_angle: Double
    let landing_x: Double
    let landing_y: Double
    let accuracy_score: Double
    let total_throws: Int
    let updated_at: Date
}

// /teams/{teamId}/players/{playerId}/monthly_summaries/{monthId}
struct MonthlySummaryModel: Identifiable, Codable {
    var id: String { month_id }
    let month_id: String            // e.g. "2025-10"
    let avg_accuracy: Double
    let avg_release_angle: Double
    let total_pitches: Int
    let heatmap: [HeatPoint]
    let improvement_rate: Double
    let updated_at: Date
}

struct HeatPoint: Codable {
    let x: Double
    let y: Double
    let density: Double
}

// /teams/{teamId}/players/{playerId}/heatmap/{heatmapId}
struct HeatmapModel: Identifiable, Codable {
    var id: String { heatmap_id }   // "current" | "2025-10"
    let heatmap_id: String
    let points: [Point2D]
    let density_map: Quadrants
    let avg_accuracy: Double
    let total_sessions_included: Int
    let last_updated: Date
}

struct Point2D: Codable { let x: Double; let y: Double }
struct Quadrants: Codable {
    let top_left: Double
    let top_right: Double
    let bottom_left: Double
    let bottom_right: Double
}

// /analytics/{teamId}
struct TeamAnalyticsModel: Identifiable, Codable {
    var id: String { team_id }
    let team_id: String
    let total_pitches: Int
    let team_accuracy_avg: Double
    let most_improved_player: String
    let team_heatmap: [HeatPoint]
    let updated_at: Date
}
