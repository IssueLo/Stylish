//
//  OrderListProvider.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/8/14.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import Foundation

typealias OrderListHandler = (Result<[OrderList]>) -> Void

typealias OrderListResponse = (Result<STSuccessParser<[OrderList]>>) -> Void

typealias OrderProfileHandler = (Result<UserProfile>) -> Void

typealias OrderProfileResponse = (Result<STSuccessParser<UserProfile>>) -> Void

class OrderListProvider {
    
    let decoder = JSONDecoder()
    
    func fetchOrderList(completion: @escaping OrderListHandler) {
        
        guard let token = KeyChainManager.shared.token else {return}
        
//        let token = "2dfbc870223545176b92a73863ae1c641d75c05f2220155d7cf234bb80f52aac"
        
        HTTPClient.shared.request(
        STOrderListRequest.orderList(token: token))
        { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {return}
                
                do {
                    
                        let orderList = try
                            strongSelf.decoder.decode(STSuccessParser<[OrderList]>.self, from: data)
                    
                        DispatchQueue.main.async {
                            completion(Result.success(orderList.data))
                        }
                    
                } catch {
                    
                    completion(Result.failure(error))
                    
                    print(error)
                }
                
             
            case .failure(let error):
                
                completion(Result.failure(error))
                
            }
        }
    }
    
    func fetchOrderProfile(completion: @escaping OrderProfileHandler) {
        
        guard let token = KeyChainManager.shared.token else {return}
        
//        let token = "2dfbc870223545176b92a73863ae1c641d75c05f2220155d7cf234bb80f52aac"
        
        HTTPClient.shared.request(
            STOrderListRequest.orderProfile(token: token))
        { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    let orderProfile = try
                        strongSelf.decoder.decode(UserProfile.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(Result.success(orderProfile))
                    }
                    
                } catch {
                    
                    completion(Result.failure(error))
                    
                    print(error)
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
                
            }
            
        }
       
    }
    
}

