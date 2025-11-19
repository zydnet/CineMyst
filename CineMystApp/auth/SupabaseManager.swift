//
//  SupabaseManager.swift
//  CineMystApp
//
//  Created by user@50 on 19/11/25.
//

import Foundation
import Supabase

final class SupabaseManager {
    
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        let url = URL(string: "https://jylcmqgtajaisxpwcnku.supabase.co")!
        let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp5bGNtcWd0YWphaXN4cHdjbmt1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1NDM2NDgsImV4cCI6MjA3OTExOTY0OH0.o1WXpFNgebkhD3EKAJMd2vTeMFCGbRlL7htJUA7BLDo"
        
        client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: key,
            options: SupabaseClientOptions(autoRefreshToken: true, persistSession: true)
        )
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String) async throws -> AuthResponse {
        return try await client.auth.signUp(
            email: email,
            password: password
        )
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws -> AuthResponse {
        return try await client.auth.signIn(
            email: email,
            password: password
        )
    }
    
    // MARK: - Sign Out
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(email)
    }
    
    // MARK: - Current User
    var currentUser: User? {
        client.auth.currentUser
    }
}
