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
        
        for color in product.colors {
            wishColor.mapping(color)
        }
        
        for variant in product.variants {
            wishVariant.mapping(variant)
        }
        
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
            
            let fetchingwishListProducts = try viewContext.fetch(request)
            
            self.wishListProducts = fetchingwishListProducts
            
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


//extension NSSet {
//    
//}
    
    
//    func toArray<T>() -> [T] {
//        let array = self.map({ $0 as! T})
//        return array
//    }



private extension WishProduct {
    
    func mapping(_ object: Product) {
        
        detail = object.description
        
        id = object.id.int64()
        
        images = object.images
        
        mainImage = object.mainImage
        
        note = object.note
        
        place = object.place
        
        price = object.price.int64()
        
        sizes = object.sizes
        
        story = object.story
        
        texture = object.texture
        
        title = object.title
        
        wash = object.wash
        
      
        colors = NSSet(array: object.colors.map({ color in

                        let wishColor = WishColor(context: WishListManager.shared.viewContext)

                        wishColor.mapping(color)

                        return wishColor
                    })
                )
        
        
        variants = NSSet(array:
        
                    object.variants.map({ variant in
        
                        let wishVariant = WishVariant(context: WishListManager.shared.viewContext)
        
                        wishVariant.mapping(variant)
        
                        return wishVariant
                    })
                )
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


