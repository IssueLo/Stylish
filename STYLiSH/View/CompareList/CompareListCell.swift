//
//  CompareListCell.swift
//  STYLiSH
//
//  Created by 戴汝羽 on 2019/8/10.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class CompareListCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView! {
        didSet{
            backView.layer.borderColor = UIColor.black.cgColor
            backView.layer.borderWidth = 1
            backView.layer.cornerRadius = 5
            backView.clipsToBounds = true
        }
    }
    
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
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes!) {
        super.apply(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CompareListViewControllerLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * self.bounds.size.height
    }

}
