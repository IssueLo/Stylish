//
//  OrderListTableViewCell.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/8/12.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderProductBaseView: TrolleyProductBaseView!
    
    @IBOutlet weak var orderProductImage: UIImageView!
    
    func layoutView(order: LSOrder) {
        
        guard let product = order.product,
            let title = product.title,
            let size = order.seletedSize,
            let color = order.seletedColor,
            let image = product.images?[0],
            let variants = product.variants as? Set<LSVariant>
            else {
                
                return
        }
        
        orderProductBaseView.removeBtn.isHidden = true
        
        orderProductBaseView.layoutView(title: title, size: size, price: String(Int(product.price)), color: color)
        
        orderProductImage.loadImage(image)
        
        let variant: [LSVariant] = variants.compactMap({ variant in
            
            if variant.size == size && variant.colorCode == color {
                
                return variant
            }
            
            return nil
        })
        
        guard let maxNumber = variant.first?.stocks else { return }
        
//        amountLbl?.text = "x \(order.amount)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
