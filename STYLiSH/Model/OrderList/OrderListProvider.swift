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
        
        guard let token = KeyChainManager.shared.token else {return}
        
        HTTPClient.shared.request(
        STOrderListRequest.orderList(token: token))
        { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    let orderList = try
                    strongSelf.decoder.decode(STSuccessParser<[OrderList]>.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(Result.success(orderList.data))
                    }
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
                
            }
        }
    }
    
}
