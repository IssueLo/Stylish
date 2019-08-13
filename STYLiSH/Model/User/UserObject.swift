//
//  UserObject.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import Foundation

struct UserObject: Codable {

    let accessToken: String

    let user: User
    
    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
    }
}

// Add by Kevin
struct AddUserObject: Codable {
    
    let accessToken: String
    
    let user: AddUser
    
    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
    }
}

struct User: Codable {

    let id: Int

    let provider: String

    let name: String

    let email: String

    let picture: String
}

// Add by Kevin
struct AddUser: Codable {
    
    let id: Int
    
    let provider: String
    
    let name: String
    
    let email: String
}

struct Reciept: Codable {

    let number: String
}
