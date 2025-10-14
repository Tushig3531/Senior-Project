
//
//  DatabaseManager.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/14/25.
//

import Foundation // gives access to core swift classes (filemanager, string, date...)
import SQLite

final class DatabaseManager {
    static let shared = DatabaseManager()
    var db: Connection!

    // creating tables
    private let users = Table("User")
    private let teams = Table("Team")
    private let sessions = Table("Sessions")
    private let pitchingSummary = Table("Pitching_Summary")
    private let monthSummary = Table("Month_Summary")
    private let totalSummary = Table("Total_Summary")
    private let analytics = Table("Analytics")

    // creating columns for all the tables
    // user
    private let uid = Expression<String>("uid")
    private let name = Expression<String>("name")
    private let username = Expression<String>("username")
    private let email = Expression<String>("email")
    private let password = Expression<String>("password")
    private let role = Expression<String>("role")
    private let teamId = Expression<String?>("team_id")
    private let joinedAt = Expression<String?>("joined_at")
    private let profilePic = Expression<String?>("profile_pic")
    private let active = Expression<Bool>("active")

    // team
    private let team_id = Expression<String>("team_id")
    private let team_name = Expression<String>("team_name")
    private let coach_id = Expression<String>("coach_id")
    private let team_code = Expression<String>("team_code")
    private let created_at = Expression<String?>("created_at")
    private let is_active = Expression<Bool>("is_active")
    private let video_retention_days = Expression<Int>("video_retention_days")

    // sessions
    private let s_id = Expression<String>("s_id")
    private let player_id = Expression<String>("player_id")
    private let video_url = Expression<String?>("video_url")
    private let release_angle = Expression<Double?>("release_angle")
    private let landing_x = Expression<Double?>("landing_x")
    private let landing_y = Expression<Double?>("landing_y")
    private let target_hit = Expression<Bool?>("target_hit")
    private let accuracy_score = Expression<Double?>("accuracy_score")
    private let confidence = Expression<Double?>("confidence")
    private let consistency_index = Expression<Double?>("consistency_index")
    private let created_date = Expression<String?>("created_date")

    // pitching Summary
    private let summary_id = Expression<String>("summary_id")
    private let session_date = Expression<String?>("session_date")
    private let avg_release_angle = Expression<Double?>("avg_release_angle")
    private let avg_landing_x = Expression<Double?>("avg_landing_x")
    private let avg_landing_y = Expression<Double?>("avg_landing_y")
    private let avg_accuracy = Expression<Double?>("avg_accuracy")
    private let total_throws = Expression<Int?>("total_throws")
    private let updated_at = Expression<String?>("updated_at")

    // month Summary
    private let month_id = Expression<String>("month_id")
    private let month_year = Expression<String?>("month_year")
    private let total_pitches = Expression<Int?>("total_pitches")
    private let heatmap = Expression<String?>("heatmap")
    private let improvement_rate = Expression<Double?>("improvement_rate")

    // total Summary
    private let total_id = Expression<String>("total_id")
    private let total_sessions = Expression<Int?>("total_sessions")
    private let total_heatmap = Expression<String?>("total_heatmap")
    private let last_updated = Expression<String?>("last_updated")

    // analytics
    private let analytics_id = Expression<String>("analytics_id")
    private let team_accuracy_avg = Expression<Double?>("team_accuracy_avg")
    private let most_improved_player = Expression<String?>("most_improved_player")
    private let team_heatmap = Expression<String?>("team_heatmap")

    // initialzing
    // once the init runs shared instance will be created
    // connects to the database and creates all the tables
    private init() {
        connect()
        createAllTables()
    }

    // connection test
    private func connect() {
        do {
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let dbPath = "\(path)/BaseballAnalytics.sqlite3"
                db = try Connection(dbPath)
                print("Database connected at: \(dbPath)")
            } catch {
                print("Failed to connect to database: \(error)")
            }
            }

    // creating tables
    private func createAllTables() {
        do {
            // user
            try db.run(users.create(ifNotExists: true) { t in // if table is not existing create these
                t.column(uid, primaryKey: true)
                t.column(name)
                t.column(username, unique: true)
                t.column(email, unique: true)
                t.column(password)
                t.column(role)
                t.column(teamId)
                t.column(joinedAt)
                t.column(profilePic)
                t.column(active, defaultValue: true)
            })

            // team
            try db.run(teams.create(ifNotExists: true) { t in
                t.column(team_id, primaryKey: true)
                t.column(team_name)
                t.column(coach_id)
                t.column(team_code, unique: true)
                t.column(created_at)
                t.column(is_active, defaultValue: true)
                t.column(video_retention_days)
            })

            // sessions
            try db.run(sessions.create(ifNotExists: true) { t in
                t.column(s_id, primaryKey: true)
                t.column(player_id)
                t.column(team_id)
                t.column(video_url)
                t.column(release_angle)
                t.column(landing_x)
                t.column(landing_y)
                t.column(target_hit)
                t.column(accuracy_score)
                t.column(confidence)
                t.column(consistency_index)
                t.column(created_date)
            })

            // day summary
            try db.run(pitchingSummary.create(ifNotExists: true) { t in
                t.column(summary_id, primaryKey: true)
                t.column(player_id)
                t.column(team_id)
                t.column(session_date)
                t.column(avg_release_angle)
                t.column(avg_landing_x)
                t.column(avg_landing_y)
                t.column(avg_accuracy)
                t.column(total_throws)
                t.column(heatmap)
                t.column(updated_at)
            })

            // month summary
            try db.run(monthSummary.create(ifNotExists: true) { t in
                t.column(month_id, primaryKey: true)
                t.column(player_id)
                t.column(team_id)
                t.column(month_year)
                t.column(avg_accuracy)
                t.column(avg_release_angle)
                t.column(total_pitches)
                t.column(heatmap)
                t.column(improvement_rate)
                t.column(updated_at)
            })

            // total summary
            try db.run(totalSummary.create(ifNotExists: true) { t in
                t.column(total_id, primaryKey: true)
                t.column(player_id)
                t.column(team_id)
                t.column(total_pitches)
                t.column(total_sessions)
                t.column(avg_accuracy)
                t.column(avg_release_angle)
                t.column(total_heatmap)
                t.column(last_updated)
            })

            // analytics
            try db.run(analytics.create(ifNotExists: true) { t in
                t.column(analytics_id, primaryKey: true)
                t.column(team_id)
                t.column(total_pitches)
                t.column(team_accuracy_avg)
                t.column(most_improved_player)
                t.column(team_heatmap)
                t.column(updated_at)
            })

            print("All tables created successfully")
        } catch {
            print("Table creation failed: \(error)")
        }
    }

    // user insert function
    // this function basically inserts iserts a new record into the user table, and stores it safely in the database
    func insertUser(uid: String, name: String, username: String, email: String, password: String, role: String) {
        do {
            let insert = users.insert(
                self.uid <- uid,
                self.name <- name,
                self.username <- username,
                self.email <- email,
                self.password <- password,
                self.role <- role,
                self.active <- true
            )
            try db.run(insert)
            print("User inserted: \(username)")
        } catch {
            print("Insert failed: \(error)")
        }
    }
    //fetching user function
    // it fetches all rows from the user table, and lists all the users and will be used in admin page
    func fetchUsers() -> [String] {
        var result: [String] = []
        do {
            for user in try db.prepare(users) {
                result.append("\(user[name]) (\(user[role]))")
            }
        } catch {
            print("Fetch failed: \(error)")
        }
        return result
    }
    
    // verifying login credentials
    // it looks for a user record that matches both the username and password.
    func verifyUser(username: String, password: String) -> Bool {
        do {
            let query = users.filter(self.username == username && self.password == password)
            return try db.scalar(query.count) > 0
        } catch {
            print("Login check failed: \(error)")
            return false
        }
    }

    // inserting a new team record
    // this is basically used when a coach creates a new team
    func insertTeam(id: String, name: String, coach: String, code: String) {
        do {
            let insert = teams.insert(
                self.team_id <- id,
                self.team_name <- name,
                self.coach_id <- coach,
                self.team_code <- code,
                self.video_retention_days <- 10
            )
            try db.run(insert)
            print("Team inserted: \(name)")
        } catch {
            print("Insert failed: \(error)")
        }
    }
}
