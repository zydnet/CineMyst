//
//  Post.swift
//  CineMystApp
//
//  Created by user@50 on 11/11/25.
//


import Foundation

struct Post {
    let username: String
    let title: String
    let caption: String
    let likes: Int
    let comments: Int
    let shares: Int
    let imageName: String   // main media image
    let userImageName: String? // avatar image name (optional)
}
