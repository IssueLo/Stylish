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
    @IBOutlet weak var showEmotyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWishes()
        
        setUpFlatCardView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchWishes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        WishListManager.shared.saveAll { _ in }
    }
    
    var wishes: [WishProduct] = [] {
        
        didSet {
        
            wishListCollectionView.reloadData()
            
            if wishes.count == 0 {
                
                showEmotyView.isHidden = false
                
                wishListCollectionView.isHidden = true
            } else {
                
                showEmotyView.isHidden = true
                
                wishListCollectionView.isHidden = false
                
            }
        }
    }
    
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
    
    func deleteWishes(at index: Int) {
        
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
        wishListCollectionView.collectionViewLayout = cardLayout
        wishListCollectionView.lk_registerCellWithNib(identifier: String(describing: WishListCell.self), bundle: nil)
    }

}


extension WishListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("＝＝＝願望清單商品數：\(wishes.count)＝＝＝")
        
        return wishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = wishListCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WishListCell.self), for: indexPath)
        
        guard let wishCell = cell as? WishListCell else { return cell }
        
        wishCell.wishTitle.text = wishes[indexPath.item].title ?? "(品名)"
        
        wishCell.wishImage.loadImage(wishes[indexPath.item].mainImage)
        
        wishCell.wishPrice.text = String(wishes[indexPath.item].price)
        
        wishCell.touchHandler = { [weak self] in
            
            self?.deleteWishes(at: indexPath.item)
        }
        
        return wishCell
    }
    
    
}


