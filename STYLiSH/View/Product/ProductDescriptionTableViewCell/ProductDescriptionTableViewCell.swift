//
//  ProductDescriptionTableViewCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/3.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class ProductDescriptionTableViewCell: ProductBasicCell {

    @IBOutlet weak var addToWishBtn: UIButton!
    
    @IBOutlet weak var titleLbl: UILabel!

    @IBOutlet weak var priceLbl: UILabel!

    @IBOutlet weak var idLbl: UILabel!

    @IBOutlet weak var detailLbl: UILabel!

    @IBAction func sharingBtnPressed(_ sender: Any) {
        
//        delegate?.showSharingPage()
        delegate?.shareToFB()
    }
    
    // Add By Kevin
    @IBOutlet weak var addToCompareListBtn: UIButton!
    
    @IBAction func addToCompareList(_ sender: Any) {
        
        delegate?.addToCompareList()
        
        addToCompareListBtn.isEnabled = false
    }
    
    // Add By Sylvia
    @IBAction func addToWishList(_ sender: Any) {
        
        delegate?.addToWishList()
        
        addToWishBtn.isEnabled = false
        
        addToWishBtn.setImage(UIImage(named: "icons8-in-love-24"), for: .init())
        // icons8-in-love-50-2
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutCell(product: Product) {

        titleLbl.text = product.title

        priceLbl.text = "NT$ \(product.price)"

        idLbl.text = String(product.id)

        detailLbl.text = product.story
    }
    
    weak var delegate: ProductDescriptionTableViewCellDelegate?
}

protocol ProductDescriptionTableViewCellDelegate: AnyObject {
    func showSharingPage()
    func shareToFB()
    func addToCompareList()
    func addToWishList()
}
