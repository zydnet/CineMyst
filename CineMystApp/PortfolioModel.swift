//
//  PortfolioModel.swift
//  CineMystApp
//

import Foundation

struct PortfolioData {
    let name: String
    let role: String
    let about: String
    let achievements: [String]
    let workshops: [Workshop]
    let films: [Film]
}

struct Workshop {
    let title: String
    let type: String
    let location: String
    let duration: String
}

struct Film {
    let title: String
    let year: String
    let role: String
    let duration: String
    let production: String
    let imageName: String
}
