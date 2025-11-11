//
//  Jobs.swift
//  CineMystApp
//
//  Created by user@50 on 11/11/25.
//
import Foundation

struct Job {
    let role: String         // e.g. "Lead Actor - Drama Series"
    let company: String      // e.g. "YRF Casting"
    let location: String     // e.g. "Mumbai, India"
    let pay: String          // e.g. "₹5k/day"
    let tag: String          // e.g. "Web Series"
    let applicants: Int      // e.g. 8
    let daysLeft: Int        // e.g. 2
    let logoName: String     // image asset name for the company/job icon
}
