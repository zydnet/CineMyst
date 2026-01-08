//
//  AuthManager.swift
//  CineMystApp
//
//  Created by user@50 on 19/11/25.
//

import Foundation
import Supabase
import UIKit

final class AuthManager {
    static let shared = AuthManager()
    private init() {}

    private var client: SupabaseClient { supabase }

    // MARK: - Sign Up
    func signUp(email: String, password: String, redirectTo: URL? = nil) async throws {
        if let redirect = redirectTo {
            try await client.auth.signUp(email: email, password: password, redirectTo: redirect)
        } else {
            try await client.auth.signUp(email: email, password: password)
        }
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(email: email, password: password)
    }

    // MARK: - Passwordless / Magic Link (OTP)
    func signInWithMagicLink(email: String, redirectTo: URL? = nil) async throws {
        if let redirect = redirectTo {
            try await client.auth.signInWithOTP(email: email, redirectTo: redirect)
        } else {
            try await client.auth.signInWithOTP(email: email)
        }
    }

    // MARK: - Reset Password (send email)
    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(email)
    }

    // MARK: - Sign Out
    func signOut() async throws {
        try await client.auth.signOut()
    }

    // MARK: - Current user/session (read-only helpers)
    var currentUser: User? {
        client.auth.currentUser
    }

    func currentSession() async throws -> Session? {
        return try await client.auth.session
    }

    // MARK: - Auth state listening
    private var subscriptionStorage: Any?

    func startListening() {
        Task {
            let subs = await client.auth.onAuthStateChange { event, session in
                NotificationCenter.default.post(name: .authStateChanged,
                                                object: nil,
                                                userInfo: ["event": event, "session": session as Any])
            }
            self.subscriptionStorage = subs
        }
    }

    func stopListening() {
        subscriptionStorage = nil
    }
    
    // MARK: - Profile Picture Upload
    func uploadProfilePicture(_ image: UIImage, userId: UUID) async throws -> String {
        // Verify we have a valid session first
        guard let session = try await currentSession() else {
            print("❌ No valid session when uploading profile picture")
            throw ProfileError.invalidSession
        }
        
        print("✅ Session valid, user: \(session.user.id)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            print("❌ Failed to compress image")
            throw ProfileError.imageCompressionFailed
        }
        
        print("📸 Image compressed, size: \(imageData.count) bytes")
        
        // File path MUST be: userId/filename.jpg to match policy
        let fileName = "\(userId.uuidString)/profile.jpg"
        print("📁 Uploading to path: \(fileName)")
        
        do {
            try await client.storage
                .from("profile-pictures")
                .upload(
                    path: fileName,
                    file: imageData,
                    options: FileOptions(
                        cacheControl: "3600",
                        contentType: "image/jpeg",
                        upsert: true
                    )
                )
            
            print("✅ Upload successful!")
            
            let publicURL = try client.storage
                .from("profile-pictures")
                .getPublicURL(path: fileName)
            
            print("🔗 Public URL: \(publicURL.absoluteString)")
            
            return publicURL.absoluteString
            
        } catch let error as StorageError {
            print("❌ Storage Error:")
            print("   Status Code: \(error.statusCode ?? "nil")")
            print("   Message: \(error.message)")
            print("   Error: \(error.error ?? "nil")")
            throw error
        } catch {
            print("❌ Unknown Error: \(error)")
            throw error
        }
    }
    
    // MARK: - Save Profile Data
    func saveProfile(_ profileData: ProfileData) async throws {
        print("🚀 Starting saveProfile...")
        
        guard let session = try await currentSession() else {
            print("❌ No session found")
            throw ProfileError.invalidSession
        }
        
        let userId = session.user.id
        print("👤 User ID: \(userId)")
        print("📧 Email: \(session.user.email ?? "no email")")
        print("🔑 Access Token exists: \(session.accessToken.isEmpty == false)")
        
        // Upload profile picture first if exists
        var profilePictureURL: String? = nil
        if let image = profileData.profilePicture {
            print("📸 Uploading profile picture...")
            do {
                profilePictureURL = try await uploadProfilePicture(image, userId: userId)
            } catch {
                print("❌ Profile picture upload failed: \(error)")
                // Don't throw - continue saving profile without picture
                print("⚠️ Continuing without profile picture...")
            }
        } else {
            print("⏭️ No profile picture, skipping upload")
        }
        
        print("💾 Saving profile to database...")
        
        // Create profile struct for encoding
        let profile = ProfileRecord(
            id: userId.uuidString,
            dateOfBirth: ISO8601DateFormatter().string(from: profileData.dateOfBirth ?? Date()),
            role: profileData.role?.rawValue.lowercased() ?? "",
            employmentStatus: profileData.employmentStatus ?? "",
            locationState: profileData.locationState,
            postalCode: profileData.postalCode,
            locationCity: profileData.locationCity,
            profilePictureUrl: profilePictureURL
        )
        
        do {
            try await client.from("profiles")
                .upsert(profile)
                .execute()
            
            print("✅ Profile saved to database")
        } catch {
            print("❌ Database error saving profile: \(error)")
            throw error
        }
        
        // Save role-specific data
        if profileData.role == .artist {
            print("🎭 Saving artist profile...")
            try await saveArtistProfile(profileData, userId: userId)
        } else if profileData.role == .castingProfessional {
            print("🎬 Saving casting profile...")
            try await saveCastingProfile(profileData, userId: userId)
        }
        
        print("🎉 All profile data saved successfully!")
    }
    
    // MARK: - Private Helper Methods
    private func saveArtistProfile(_ data: ProfileData, userId: UUID) async throws {
        let artistProfile = ArtistProfileRecord(
            id: userId.uuidString,
            primaryRoles: Array(data.primaryRoles),
            careerStage: data.careerStage,
            skills: data.skills,
            experienceYears: data.experienceYears,
            travelWilling: data.travelWilling
        )
        
        do {
            try await client.from("artist_profiles")
                .upsert(artistProfile)
                .execute()
            
            print("✅ Artist profile saved")
        } catch {
            print("❌ Error saving artist profile: \(error)")
            throw error
        }
    }
    
    private func saveCastingProfile(_ data: ProfileData, userId: UUID) async throws {
        let castingProfile = CastingProfileRecord(
            id: userId.uuidString,
            specificRole: data.specificRole,
            companyName: data.companyName,
            castingTypes: Array(data.castingTypes),
            castingRadius: data.castingRadius,
            contactPreference: data.contactPreference
        )
        
        do {
            try await client.from("casting_profiles")
                .upsert(castingProfile)
                .execute()
            
            print("✅ Casting profile saved")
        } catch {
            print("❌ Error saving casting profile: \(error)")
            throw error
        }
    }
}

// MARK: - Database Record Structures
struct ProfileRecord: Encodable {
    let id: String
    let dateOfBirth: String
    let role: String
    let employmentStatus: String
    let locationState: String?
    let postalCode: String?
    let locationCity: String?
    let profilePictureUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case dateOfBirth = "date_of_birth"
        case role
        case employmentStatus = "employment_status"
        case locationState = "location_state"
        case postalCode = "postal_code"
        case locationCity = "location_city"
        case profilePictureUrl = "profile_picture_url"
    }
}

struct ArtistProfileRecord: Encodable {
    let id: String
    let primaryRoles: [String]
    let careerStage: String?
    let skills: [String]
    let experienceYears: String?
    let travelWilling: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case primaryRoles = "primary_roles"
        case careerStage = "career_stage"
        case skills
        case experienceYears = "experience_years"
        case travelWilling = "travel_willing"
    }
}

struct CastingProfileRecord: Encodable {
    let id: String
    let specificRole: String?
    let companyName: String?
    let castingTypes: [String]
    let castingRadius: Int?
    let contactPreference: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case specificRole = "specific_role"
        case companyName = "company_name"
        case castingTypes = "casting_types"
        case castingRadius = "casting_radius"
        case contactPreference = "contact_preference"
    }
}

// MARK: - Profile Errors
enum ProfileError: Error {
    case imageCompressionFailed
    case invalidSession
    case uploadFailed
}

extension Notification.Name {
    static let authStateChanged = Notification.Name("AuthManager.authStateChanged")
}
