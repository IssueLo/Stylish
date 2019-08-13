//
//  WishListManager.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/8/12.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//


import CoreData

typealias WishProductResults = (Result<[WishProduct]>) -> Void

typealias WishProductResult = (Result<WishProduct>) -> Void

@objc class WishListManager: NSObject {
    
    private enum Entity: String, CaseIterable {
        
        case wishListProduct = "WishProduct"
        
        case wishListColor = "WishColor"
        
        case wishListVarint = "WishVariant"
        
    }
    
    static let shared = WishListManager()
    
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
    
    
     @objc dynamic var wishListProducts: [WishProduct] = []
    
    
    func saveWishProduct(
        product: Product,
        completion: (Result<Void>) -> Void) {
        
        let wishProduct = WishProduct(context: viewContext)
        
        let wishColor = WishColor(context: viewContext)
        
        let wishVariant = WishVariant(context: viewContext)
        
        wishProduct.mapping(product)
        
        
        do {
            
            try viewContext.save()
            
            completion(Result.success(()))
            
            fetchWishProducts()
            
        } catch {
            
            completion(Result.failure(error))
        }
    }
    
    func deleteWishProduct(_ wishProduct: WishProduct, completion: (Result<Void>) -> Void) {
        
        do {
            
            viewContext.delete(wishProduct)
            
            try viewContext.save()
            
            completion(Result.success(()))
            
            fetchWishProducts()
            
        } catch {
            
            completion(Result.failure(error))
        }
    }
    
    func updateWishProduct(completion: (Result<Void>) -> Void) {
        
        do {
            
            try viewContext.save()
            
            completion(Result.success(()))
            
            fetchWishProducts()
            
        } catch {
            
            completion(Result.failure(error))
        }
    }
    
    
    func fetchWishProducts(completion: WishProductResults? = nil) {
        
        let request = NSFetchRequest<WishProduct>(entityName: Entity.wishListProduct.rawValue)
        
        do {
            
            let wishListProducts = try viewContext.fetch(request)
            
            self.wishListProducts = wishListProducts
            
            completion?(Result.success(wishListProducts))
            
        } catch {
            
            completion?(Result.failure(error))
        }
    }
    
    
    func saveAll(completion: (Result<Void>) -> Void) {
        
        do {
            
            try viewContext.save()
            
            completion(Result.success(()))
            
            fetchWishProducts()
            
        } catch {
            
            completion(Result.failure(error))
        }
    }
    
    
    func deleteAllWish(completion: (Result<Void>) -> Void) {
        
        for item in Entity.allCases {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: item.rawValue)
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                
                try viewContext.execute(deleteRequest)
                
                fetchWishProducts()
                
            } catch {
                
                completion(Result.failure(error))
                
                return
            }
        }
        
        completion(Result.success(()))
    }
    
}


private extension WishProduct {
    
    func mapping(_ object: Product) {
        
        mainImage = object.mainImage
        
        price = object.price.int64()
        
        title = object.title
    }
}

private extension WishColor {
    
    func mapping(_ object: Color) {
        
        code = object.code
        
        name = object.name
    }
}

private extension WishVariant {
    
    func mapping(_ object: Variant) {
        
        colorCode = object.colorCode
        
        size = object.size
        
        stocks = object.stock.int64()
    }
}
