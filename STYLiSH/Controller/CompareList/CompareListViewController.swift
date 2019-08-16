//
//  CompareListViewController.swift
//  STYLiSH
//
//  Created by 戴汝羽 on 2019/8/10.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class CompareListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
        
            collectionView.delegate = self
            
            collectionView.dataSource = self
        }
    }
    
    @IBAction func deleteAllCPProduct(_ sender: Any) {
        
        CompareListManager.shared.deleteAllProduct(completion: { _ in})
        
        compareListProducts = []
    }
    
    @IBAction func goBackPage(_ sender: UIBarButtonItem) {
    
         dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var coverView: UIView! {
        didSet {
            coverViewAnimate()
        }
    }
    
    func coverViewAnimate() {
        
        let bounds = self.coverView.bounds
        UIView.animate(withDuration: 2, delay: 0.0, usingSpringWithDamping: 0.10, initialSpringVelocity: 50, options: .transitionFlipFromTop
            , animations: {
            self.coverView.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y + 70, width: bounds.size.width, height: bounds.size.height)
        }, completion: nil)
    }
    
    
    
    var compareListProducts: [CPProduct] = [] {
        
        didSet {
            
            collectionView.reloadData()
            
            if compareListProducts.count == 0 {
                
                coverView.isHidden = false
                                
                collectionView.isHidden = true
                
                coverViewAnimate()
                
                navigationItem.title = "小孩子才做選擇"
                
//                checkoutBtn.isEnabled = false
//
//                checkoutBtn.backgroundColor = UIColor.B4
                
            } else {
                
                coverView.isHidden = true
                
                collectionView.isHidden = false
                
                
                
                navigationItem.title = "比較清單"
                
//                checkoutBtn.isEnabled = true
//
//                checkoutBtn.backgroundColor = UIColor.B1
            }
            
            view.layoutIfNeeded()
        }
    }
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.lk_registerCellWithNib(identifier: String(describing: CompareListCell.self), bundle: nil)
        
        if UIScreen.height > 750 {
            
            collectionView.contentInset = UIEdgeInsets(top: 0,
                                                       left: 16,
                                                       bottom: UIScreen.height - 622 ,
                                                       right: 16)
        } else {
            
            collectionView.contentInset = UIEdgeInsets(top: 0,
                                                       left: 16,
                                                       bottom: UIScreen.height - 564 ,
                                                       right: 16)
        }
        
        fetchData()
        
        print(UIScreen.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        CompareListManager.shared.saveAll(completion: { _ in })
    }
    
    //MARK: - Action
    
    func fetchData() {
        
        CompareListManager.shared.fetchCPProducts(completion: { result in
            
            switch result {
                
            case .success(let compareListProducts):
                
                self.compareListProducts = compareListProducts
                
            case .failure:
                
                LKProgressHUD.showFailure(text: "讀取資料發生錯誤！")
            }
        })
    }
    
    func deleteData(at index: Int) {
        
        CompareListManager.shared.deleteCPProduct(
            compareListProducts[index],
            completion: { result in
                
                switch result {
                    
                case .success:
                    
                    compareListProducts.remove(at: index)
                                        
                case .failure:
                    
                    LKProgressHUD.showFailure(text: "刪除資料失敗！")
                }
        })
    }

}

extension CompareListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return compareListProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CompareListCell.self),
            for: indexPath
        )
        
        guard let compareCell = cell as? CompareListCell else { return cell }
        
        compareCell.titleLabel.text = compareListProducts[indexPath.row].title
        
        compareCell.priceLabel.text = String(compareListProducts[indexPath.row].price)
        
        compareCell.productImage.loadImage(compareListProducts[indexPath.row].mainImage)
        
        compareCell.materialLabel.text = compareListProducts[indexPath.row].texture
        
        compareCell.washLabel.text = compareListProducts[indexPath.row].wash
        print(compareListProducts[indexPath.row])
        compareCell.placeOfProductionLabel.text = compareListProducts[indexPath.row].place
        
        compareCell.touchHandler = { [weak self] in
            
            self?.deleteData(at: indexPath.item)
        }
        
        return compareCell
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        // 在動畫效果之前先進行下列操作
//        // 將透明度設為 0，再把 Cell 位移到右下角，並且長寬縮小 0.5 倍。
//        cell.alpha = 0
//        cell.transform = CGAffineTransform(translationX: cell.bounds.width / 2, y: cell.bounds.height / 3).concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5))
//        
//        UIView.animate(withDuration: 0.4) {
//            // 執行動畫效果
//            // 將透明度改回 1，並取消所有的變形效果，回到原樣及位置。
//            cell.alpha = 1
//            cell.transform = CGAffineTransform.identity
//        }
//    }
}



class CompareListViewControllerViewLayout: UICollectionViewLayout{
    
    //    weak var delegate: CollectionViewLayoutDelegate?
    
    let itemSize = CGSize(width: 180, height: 500)
    
    
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ?
            -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
    }
    var angle: CGFloat {
        return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize.width -
            collectionView!.bounds.size.width)
    }
    
    
    
    var radius: CGFloat = 3000 {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return atan(itemSize.width / radius)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width,
                      height: collectionView!.bounds.size.height)
        //        print(collectionViewContentSize)
    }
    
    var layoutAttributesClass: AnyClass {
        return CompareListViewControllerViewLayout.self
    }
    
    var attributesList = [CompareListViewControllerLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        
        let centerX = collectionView!.contentOffset.x + (collectionView!.bounds.size.width / 2.0)
        
        let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
        
        
        
        attributesList = (0..<collectionView!.numberOfItems(inSection: 0)).map { (i)
            -> CompareListViewControllerLayoutAttributes in
            // 1
            let attributes = CompareListViewControllerLayoutAttributes(forCellWith: NSIndexPath(item: i,
                                                                                                section: 0) as IndexPath)
            attributes.size = self.itemSize
            // 2
            attributes.center = CGPoint(x: centerX, y: self.collectionView!.bounds.midY)
            // 3
            //            attributes.angle = self.anglePerItem * CGFloat(i)
            attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
            
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            
            return attributes
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    //设置item用到的attribute
    func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath)
        -> UICollectionViewLayoutAttributes! {
            return attributesList[indexPath.row]
    }
    
    
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}

class CompareListViewControllerLayoutAttributes: UICollectionViewLayoutAttributes {
    // 1
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    var angle: CGFloat = 0 {
        // 2
        didSet {
            zIndex = Int(angle * 1000000)
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    // 3
    override func copy(with zone: NSZone? = nil) -> Any {
        let copiedAttributes: CompareListViewControllerLayoutAttributes =
            super.copy(with: zone) as! CompareListViewControllerLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
}
