//
//  OnboardingCoordinator.swift
//  CineMystApp
//
//  Created by user@50 on 08/01/26.
//

// OnboardingCoordinator.swift
import SwiftUI

class OnboardingCoordinator: ObservableObject {
    @Published var currentStep: OnboardingStep = .birthday
    @Published var profileData = ProfileData()
    
    enum OnboardingStep {
        case birthday
        case roleSelection
        case roleDetails
        case location
        case profilePicture
    }
    
    func nextStep() {
        switch currentStep {
        case .birthday:
            currentStep = .roleSelection
        case .roleSelection:
            currentStep = .roleDetails
        case .roleDetails:
            currentStep = .location
        case .location:
            currentStep = .profilePicture
        case .profilePicture:
            break
        }
    }
}

struct ProfileData {
    var dateOfBirth: Date?
    var role: UserRole?
    var employmentStatus: String?
    
    // Artist fields
    var primaryRoles: Set<String> = []
    var careerStage: String?
    var skills: [String] = []
    var experienceYears: String?
    var travelWilling: Bool = false
    
    // Casting Professional fields
    var specificRole: String?
    var companyName: String?
    var castingTypes: Set<String> = []
    var castingRadius: Int?
    var contactPreference: String?
    
    // Location
    var locationState: String?
    var postalCode: String?
    var locationCity: String?
    
    // Profile picture
    var profilePicture: UIImage?
}

enum UserRole: String, CaseIterable {
    case artist = "Artist"
    case castingProfessional = "Casting Professional"
}
