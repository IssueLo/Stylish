//
//  ProductShareViewController.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/8/10.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit
import FacebookShare
import FBSDKShareKit

class ProductShareViewController: STBaseViewController {
    
    
    @IBOutlet weak var sharingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 加圓角
        sharingView.clipsToBounds = true
        sharingView.layer.cornerRadius = 25
        sharingView.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner ]
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
  

    
    

}
