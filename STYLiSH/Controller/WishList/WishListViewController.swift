//
//  WishListViewController.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/8/12.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class WishListViewController: UIViewController {
    
    
    @IBOutlet weak var wishListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWishes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchWishes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        WishListManager.shared.saveAll { _ in }
    }
    
    var wishes: [WishProduct] = []
    
    func fetchWishes() {
        
        WishListManager.shared.fetchWishProducts { fetchResult in
            
            switch fetchResult {
            
            case .success(let wishes):
                
                self.wishes = wishes
                
            case .failure:
                
                LKProgressHUD.showFailure(text: "讀取願望清單錯誤！")
                
            }
        }
    }
    
    func deleteWishws(at index: Int) {
        
        WishListManager.shared.deleteWishProduct(wishes[index]) {
            deleteResult in
            
            switch deleteResult {
                
              case .success:
                
                wishes.remove(at: index)
                
              case .failure:
                
                LKProgressHUD.showFailure(text: "刪除願望失敗！要不要考慮留下？")
                
            }
        }
    }
    
    func deleteAllWishes() {
        
        WishListManager.shared.deleteAllWish(completion: { _ in })
    }
    
    lazy var cardLayout: FlatCardCollectioViewLayout = {
        
        let layout = FlatCardCollectioViewLayout()
        layout.itemSize = CGSize(width: 220, height: 350)
        return layout
    }()
    
    private func setUpFlatCardView() {
        
        wishListCollectionView.dataSource = self
        wishListCollectionView.delegate = self
        wishListCollectionView.showsVerticalScrollIndicator = false
        
        
    }

}


extension WishListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("＝＝＝願望清單商品數：\(wishes.count)＝＝＝")
        
        return wishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}


