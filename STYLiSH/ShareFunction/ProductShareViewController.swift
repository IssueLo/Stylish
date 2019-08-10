//
//  ProductShareViewController.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/8/10.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit
import Social

class ProductShareViewController: UIViewController {

    @IBOutlet weak var sharingBtn: UIButton!
    @IBOutlet weak var sharingText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showShareOptions(sender: AnyObject) {
    }

    

}
