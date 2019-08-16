//
//  UserRequest.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import Foundation

enum STUserRequest: STRequest {

    case signin(String)

    case checkout(token: String, body: Data?)
    
    case signup(name: String, email: String, password: String)
    
    case nativesignin(email: String, password: String)

    var headers: [String: String] {

        switch self {

        case .signin:

            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]

        case .checkout(let token, _):

            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
            
        case .signup:
            
            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]
            
        case .nativesignin:
            
            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]
        }
    }

    var body: Data? {

        switch self {

        case .signin(let token):

            let dict = [
                "provider": "facebook",
                "access_token": token
            ]
            
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)

        case .checkout(_, let body):

            return body
            print("========CHECKOUT BODY======")
            print(body)
            
            
        case .signup(let name, let email, let password):
            
            let dict = [
                "name": name,
                "email": email,
                "password": password
            ]
            
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
        case .nativesignin(let email, let password):
            
            let dict = [
                "provider": "native",
                "email": email,
                "password": password
            ]
            
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }
    }

    var method: String {

        switch self {

        case .signin, .checkout, .signup, .nativesignin: return STHTTPMethod.POST.rawValue

        }
    }

    var endPoint: String {

        switch self {

        case .signin, .nativesignin: return "/user/signin"

        case .checkout: return "/order/checkout"
            
        case .signup: return "/user/signup"
        }
    }

}
