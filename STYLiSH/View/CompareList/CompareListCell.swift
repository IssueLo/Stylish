//
//  CompareListCell.swift
//  STYLiSH
//
//  Created by 戴汝羽 on 2019/8/10.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class CompareListCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var materialLabel: UILabel!
    
    @IBOutlet weak var washLabel: UILabel!
    
    @IBOutlet weak var placeOfProductionLabel: UILabel!
        
    @IBOutlet weak var removeBtn: UIButton!
    
    var touchHandler: (() -> Void)? {
        
        didSet {
            
            if touchHandler == nil {

                removeBtn.isHidden = true

            } else {
            
                removeBtn.isHidden = false
            }
        }
    }
    
    @IBAction func didTouchRemoveButton(_ sender: UIButton) {
        
        touchHandler?()
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
