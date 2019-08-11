//
//  CompareListManager.swift
//  STYLiSH
//
//  Created by 戴汝羽 on 2019/8/11.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import CoreData

typealias CPProductResults = (Result<[CPProduct]>) -> Void

typealias CPProductResult = (Result<CPProduct>) -> Void

@objc class CompareListManager: NSObject {
    
    private enum Entity: String, CaseIterable {
        
        case compareListColor = "CPColor"
        
        case compareListProduct = "CPProduct"
        
    }
    
//    private struct Order {
//
//        static let createTime = "createTime"
//    }
    
    static let shared = CompareListManager()
    
    private override init() {
        
        print(" Core data file path: \(NSPersistentContainer.defaultDirectoryURL())")
    }
    
    lazy var persistanceContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "STYLiSH")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        
        return persistanceContainer.viewContext
    }
    
//    @objc dynamic var orders: [LSOrder] = []
    
    @objc dynamic var compareListProducts: [CPProduct] = []
    
    func fetchCPProducts(completion: CPProductResults? = nil) {
        
        let request = NSFetchRequest<CPProduct>(entityName: Entity.compareListProduct.rawValue)
        
//        request.sortDescriptors = [NSSortDescriptor(key: Order.createTime, ascending: true)]
        
        do {
            
            let compareListProducts = try viewContext.fetch(request)
            
            self.compareListProducts = compareListProducts
            
            completion?(Result.success(compareListProducts))
            
        } catch {
            
            completion?(Result.failure(error))
        }
    }
    
    func saveAll(completion: (Result<Void>) -> Void) {
        
        do {
            
            try viewContext.save()
            
            completion(Result.success(()))
            
            fetchCPProducts()
            
        } catch {
            
            completion(Result.failure(error))
        }
    }
    
    func saveCPProduct(
        product: Product,
        completion: (Result<Void>) -> Void) {
        
//        let order = LSOrder(context: viewContext)
//
//        let lsProduct = LSProduct(context: viewContext)
        
        let cpProduct = CPProduct(context: viewContext)
        
        let cpColor = CPColor(context: viewContext)
        
        cpProduct.mapping(product)
        
        cpProduct.colors = cpColor

//        order.createTime = Int(Date().timeIntervalSince1970).int64()
        
        do {
            
            try viewContext.save()
            
            completion(Result.success(()))
            
            fetchCPProducts()
            
        } catch {
            
            completion(Result.failure(error))
        }
    }
    
    func deleteCPProduct(_ order: LSOrder, completion: (Result<Void>) -> Void) {
        
        do {
            
            viewContext.delete(order)
            
            try viewContext.save()
            
            completion(Result.success(()))
            
            fetchCPProducts()
            
        } catch {
            
            completion(Result.failure(error))
        }
    }
    
    func updateCPProduct(completion: (Result<Void>) -> Void) {
        
        do {
            
            try viewContext.save()
            
            completion(Result.success(()))
            
            fetchCPProducts()
            
        } catch {
            
            completion(Result.failure(error))
        }
    }
    
    func deleteAllProduct(completion: (Result<Void>) -> Void) {
        
        for item in Entity.allCases {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: item.rawValue)
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                
                try viewContext.execute(deleteRequest)
                
                fetchCPProducts()
                
            } catch {
                
                completion(Result.failure(error))
                
                return
            }
        }
        
        completion(Result.success(()))
    }
}

private extension CPProduct {
    
    func mapping(_ object: Product) {
        
        mainImage = object.mainImage
        
        place = object.place
        
        price = object.price.int64()
        
        sizes = object.sizes
        
        texture = object.texture
        
        title = object.title
    }
}

private extension CPColor {
    
    func mapping(_ object: Color) {
        
        code = object.code
        
        name = object.name
    }
}


