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
                
                LKProgressHUD.showFailure(text: "刪除願望失敗！考慮留下？")
                
            }
        }
    }
    
    func deleteAllWishes() {
        
        WishListManager.shared.deleteAllWish(completion: { _ in })
    }
    
    lazy var cardLayout: FlatCardCollectioViewLayout = {
        
        let layout = FlatCardCollectioViewLayout()
        layout.itemSize = CGSize(width: 220, height: 350)
        layout.minimumLineSpacing = CGFloat(10)
        
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


extension WishListViewController: UICollectionViewDataSource {
    
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
        
        wishCell.layer.shadowColor = UIColor.gray.cgColor
        wishCell.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        wishCell.layer.shadowRadius = 16.0
        wishCell.layer.shadowOpacity = 0.5
        wishCell.layer.masksToBounds = false
        
        return wishCell
    }
}

extension WishListViewController: UICollectionViewDelegate {

//    private func showProductDetailViewController(product: Product) {
//
//        let vc = UIStoryboard.product.instantiateViewController(withIdentifier:
//            String(describing: ProductDetailViewController.self)
//        )
//
//        guard let detailVC = vc as? ProductDetailViewController else { return }
//
//        detailVC.product = product
//
//        show(detailVC, sender: nil)
//
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        wishListCollectionView.deselectItem(at: indexPath, animated: true)
//
//        let NScolors = wishes[indexPath.item].colors?.allObjects as! NSArray
//
//        let NSvariants = wishes[indexPath.item].variants?.allObjects as! NSArray
//
//        let objcColors = NSMutableArray(array: NScolors)
//
//        let objcVariants = NSMutableArray(array: NSvariants)
//
//        let swiftColors: [Color] = objcColors.compactMap({ $0 as? Color })
//
//        let swiftVariants: [Variant] = objcColors.compactMap({ $0 as? Variant })
//
//
//        let wishProduct = Product(
//            id: Int(wishes[indexPath.item].id),
//            title: wishes[indexPath.item].title ?? "",
//            description: wishes[indexPath.item].detail ?? "",
//            price: Int(wishes[indexPath.item].price),
//            texture: wishes[indexPath.item].texture ?? "",
//            wash: wishes[indexPath.item].wash ?? "",
//            place: wishes[indexPath.item].place ?? "",
//            note: wishes[indexPath.item].note ?? "",
//            story: wishes[indexPath.item].story ?? "",
//            colors: swiftColors,
//            sizes: wishes[indexPath.item].sizes ?? [],
//            variants: swiftVariants,
//            mainImage: wishes[indexPath.item].mainImage ?? "",
//            images: wishes[indexPath.item].images ?? [])
//
//        showProductDetailViewController(product: wishProduct)
//
//    }
}

