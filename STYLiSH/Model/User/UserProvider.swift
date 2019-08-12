//
//  UserManager.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import FBSDKLoginKit

typealias FacebookResponse = (Result<String>) -> Void

enum FacebookError: String, Error {

    case noToken = "讀取 Facebook 資料發生錯誤！"

    case userCancel

    case denineEmailPermission = "請允許存取 Facebook email！"
}

enum STYLiSHSignInError: Error {

    case noToken
}

class UserProvider {

    func signInToSTYLiSH(fbToken: String, completion: @escaping (Result<Void>) -> Void) {

        HTTPClient.shared.request(STUserRequest.signin(fbToken), completion: { result in

            switch result {

            case .success(let data):

                do {

                    let userObject = try JSONDecoder().decode(STSuccessParser<UserObject>.self, from: data)

                    KeyChainManager.shared.token = userObject.data.accessToken

                    completion(Result.success(()))

                } catch {

                    completion(Result.failure(error))
                }

            case .failure(let error):

                completion(Result.failure(error))
            }

        })
    }
    
    // Add by Kevin
    func signUpToSTYLiSH(name: String, email: String, password: String, completion: @escaping (Result<Void>) -> Void) {
        
        HTTPClient.shared.request(STUserRequest.signup(name: name, email: email, password: password), completion: { result in
            
            switch result {
                
            case .success(let data):
                
                do {
                    
                    let userObject = try JSONDecoder().decode(STSuccessParser<UserObject>.self, from: data)
                    
                    KeyChainManager.shared.token = userObject.data.accessToken
                    
                    completion(Result.success(()))
                    
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
            
        })
    }
    
    // Add by Kevin
    func nativeSignInToSTYLiSH(email: String, password: String, completion: @escaping (Result<Void>) -> Void) {
        
        HTTPClient.shared.request(STUserRequest.nativesignin(email: email, password: password), completion: { result in
            
            switch result {
                
            case .success(let data):
                
                do {
                    
                    let userObject = try JSONDecoder().decode(STSuccessParser<UserObject>.self, from: data)
                    
                    KeyChainManager.shared.token = userObject.data.accessToken
                    
                    completion(Result.success(()))
                    
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
            
        })
    }

    func loginWithFaceBook(from: UIViewController, completion: @escaping FacebookResponse) {
        
        LoginManager().logIn(permissions: ["email"], from: from, handler: { (result, error) in

            guard error == nil else { return completion(Result.failure(error!)) }

            guard let result = result else {

                let fbError = FacebookError.noToken

                LKProgressHUD.showFailure(text: fbError.rawValue)

                return completion(Result.failure(fbError))
            }

            switch result.isCancelled {

            case true: break

            case false:

                guard result.declinedPermissions.contains("email") == false else {

                    let fbError = FacebookError.denineEmailPermission

                    LKProgressHUD.showFailure(text: fbError.rawValue)

                    return completion(Result.failure(fbError))
                }

                guard let token = result.token?.tokenString else {

                    let fbError = FacebookError.noToken

                    LKProgressHUD.showFailure(text: fbError.rawValue)

                    return completion(Result.failure(fbError))
                }

                completion(Result.success(token))
            }

        })
    }

    func checkout(order: Order, prime: String, completion: @escaping (Result<Reciept>) -> Void) {

        guard let token = KeyChainManager.shared.token else {

            return completion(Result.failure(STYLiSHSignInError.noToken))
        }
        
        let body = CheckoutAPIBody(order: order, prime: prime)
        
        let request = STUserRequest.checkout(
            token: token,
            body: try? JSONEncoder().encode(body)
        )

        HTTPClient.shared.request(request, completion: { result in

            switch result {

            case .success(let data):

                do {

                    let reciept = try JSONDecoder().decode(STSuccessParser<Reciept>.self, from: data)

                    DispatchQueue.main.async {

                        completion(Result.success(reciept.data))
                    }

                } catch {

                    completion(Result.failure(error))
                }

            case .failure(let error):

                completion(Result.failure(error))
            }
        })
    }

}
