//
//  RepositoryModel.swift
//  Sygic
//
//  Created by Tobiáš Hládek on 01/03/2022.
//

import Foundation

struct RepositoryModel: Codable, Hashable {
    let fullName: String?
    let description: String?
    let updateDate: String?
    let stars: Int?
    let htmlURL: String?
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case description
        case owner
        case updateDate = "updated_at"
        case htmlURL = "html_url"
        case stars = "stargazers_count"
    }
}

struct Owner: Codable, Hashable{
    let avatarURL: String
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}
