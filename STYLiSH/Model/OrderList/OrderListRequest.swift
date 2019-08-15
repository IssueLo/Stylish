//
//  OrderListProvider.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/8/14.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import Foundation

enum STOrderListRequest: STRequest {
    
    case orderList(token: String)
    
    case orderProfile(token: String)
    
    var headers: [String: String] {
        
        switch self {
            
        case .orderList(let token): return [STHTTPHeaderField.auth.rawValue: "Bearer \(token)"]
            
        case .orderProfile(let token): return [STHTTPHeaderField.auth.rawValue: "Bearer \(token)"]
            
    
            
        }
    }
    
    var body: Data? {
        
        switch self {
            
        case .orderList: return nil
            
        case .orderProfile: return nil
            
        }
    }
    
    var method: String {
        
        switch self {
            
        case .orderList: return STHTTPMethod.GET.rawValue
            
        case .orderProfile: return STHTTPMethod.GET.rawValue
            
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .orderList: return "/user/order"
            
        case .orderProfile: return "/user/profile"
            
        }
    }
    
}
