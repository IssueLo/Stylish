//
//  UserProfileData.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/8/15.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
    
    let data: UserData
}

struct UserData: Codable {
    
    let id: Int
    
    let provider: String
    
    let name: String
    
    let email: String
    
    let picture: String?
    
    let gender: String?
    
    let birth: String?
    
    let phone: String?
    
    let location: String?
    
}
