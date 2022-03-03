//
//  RepositoryModel.swift
//  Sygic
//
//  Created by Tobiáš Hládek on 01/03/2022.
//

import Foundation

struct UsersModel: Codable, Hashable {
    let items : [UserModel]?
}

struct UserModel: Codable, Hashable {
    let login: String?
}

