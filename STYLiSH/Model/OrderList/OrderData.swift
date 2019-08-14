//
//  orderDate.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/8/14.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import Foundation

struct OrderList: Codable {
    
    let id: Int
    
    let number: Int
    
    let status: Int
    
    let details: Detail
}

struct Detail: Codable {
    
    let list: [List]
    
    let total: Int
    
    let freight: Int
    
    let payment: String
    
    let shipping: String
    
    let subtotal: Int
    
    let recipient: OrderRecipient
    
}

struct List: Codable {
    
    let id: Int
    
    let qty: Int
    
    let name: String
    
    let size: String
    
    let color: OrderColor
    
    let price: Int

}


struct OrderColor: Codable {
    
    let code: String
    
    let name: String
}

struct OrderRecipient: Codable {
    
    let name: String
    
    let time: String
    
    let email: String
    
    let phone: String
    
    let address: String
}
