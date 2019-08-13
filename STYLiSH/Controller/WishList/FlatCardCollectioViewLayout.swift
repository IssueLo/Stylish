//
//  FlatCardCollectioViewLayout.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/8/13.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class FlatCardCollectioViewLayout: UICollectionViewFlowLayout {
    
    override open func prepare() {
        
        super.prepare()
        
        scrollDirection = .vertical
        
        let verticalInset = (collectionView!.frame.size.height - itemSize.height) * 0.5
        
        let horizontalInset = (collectionView!.frame.size.width - itemSize.width) * 0.3
        
        sectionInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        
    }
    
    override open var collectionViewContentSize: CGSize {
        
        guard let collectionView = collectionView else { return CGSize.zero }
        
        let itemsCount = CGFloat(collectionView.numberOfItems(inSection: 0))
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * itemsCount)
        
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let collectionView = collectionView else { return nil }
        
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        // collectionView 中心點 Y
        let centerY = collectionView.contentOffset.y + collectionView.bounds.height / 2.0
        
        for attribute in attributes {
            
            // cell 的中心點與 collectionView 中心點間距
            let delta = Swift.abs(attribute.center.y - centerY)
            
            // 根據間隔距離計算縮放比例
            let scale = 1.3 - delta / collectionView.frame.size.height
            
            // 縮放比例
            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        return attributes
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
