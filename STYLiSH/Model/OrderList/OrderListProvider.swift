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

class OrderListProvider {
    
    let decoder = JSONDecoder()
    
    func fetchOrderList(completion: @escaping OrderListHandler) {
        
//        guard let token = KeyChainManager.shared.token else {return}
        
        let token = "2dfbc870223545176b92a73863ae1c641d75c05f2220155d7cf234bb80f52aac"
        
        HTTPClient.shared.request(
        STOrderListRequest.orderList(token: token))
        { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    let orderList = try
                    strongSelf.decoder.decode([OrderList].self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(Result.success(orderList))
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

struct OrderData: Codable {
    
    var data: [OrderList]
}
