//
//  STTabBarViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/11.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

private enum Tab {
    
    case lobby
    
    case product
    
    case profile
    
    case trolley
    
    func controller() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
        
        case .lobby: controller = UIStoryboard.lobby.instantiateInitialViewController()!
            
        case .product: controller = UIStoryboard.product.instantiateInitialViewController()!
        
        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!
        
        case .trolley: controller = UIStoryboard.trolley.instantiateInitialViewController()!
        
        }
        
        controller.tabBarItem = tabBarItem()
        
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
        
        return controller
    }
    
    func tabBarItem() -> UITabBarItem {
        
        switch self {
            
        case .lobby:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Home_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Home_Selected)
            )
            
        case .product:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Catalog_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Catalog_Selected)
            )
            
        case .trolley:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Cart_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Cart_Selected)
            )
        
        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Profile_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Profile_Selected)
            )
        }
    }
}

class STTabBarViewController: UITabBarController {

    private let tabs: [Tab] = [.lobby, .product, .trolley, .profile]
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        viewControllers = tabs.map({ $0.controller() })
    }

}