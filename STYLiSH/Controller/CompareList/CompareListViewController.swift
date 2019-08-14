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
        
//        CompareListManager.shared.deleteAllProduct(completion: { _ in})
//        
//        collectionView.reloadData()
    }
    
    @IBAction func goBackPage(_ sender: UIBarButtonItem) {
    
         dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var coverView: UIView!
    
    var compareListProducts: [CPProduct] = [] {
        
        didSet {
            
            collectionView.reloadData()
            
            if compareListProducts.count == 0 {
                
                coverView.isHidden = false
                
                collectionView.isHidden = true
                
//                checkoutBtn.isEnabled = false
//
//                checkoutBtn.backgroundColor = UIColor.B4
                
            } else {
                
                coverView.isHidden = true
                
                collectionView.isHidden = false
                
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
        
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 16,
                                                   bottom: UIScreen.height - 516 ,
                                                   right: 16)
        
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
        
        compareCell.placeOfProductionLabel.text = compareListProducts[indexPath.row].place
        
        compareCell.touchHandler = { [weak self] in
            
            self?.deleteData(at: indexPath.item)
        }
        
        return compareCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 在動畫效果之前先進行下列操作
        // 將透明度設為 0，再把 Cell 位移到右下角，並且長寬縮小 0.5 倍。
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: cell.bounds.width / 2, y: cell.bounds.height / 3).concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5))
        
        UIView.animate(withDuration: 0.4) {
            // 執行動畫效果
            // 將透明度改回 1，並取消所有的變形效果，回到原樣及位置。
            cell.alpha = 1
            cell.transform = CGAffineTransform.identity
        }
    }
}

//@IBAction func addToCompareListBtn(_ sender: UIButton) {
//
//    if productPickerView.superview == nil {
//
//        showProductPickerView()
//
//    } else {
//
//        guard let product = product else { return }
//        
//        CompareListManager.shared.saveCPProduct(
//            product: product,
//            completion: { result in
//
//                switch result {
//
//                case .success:
//
//                    LKProgressHUD.showSuccess()
//
//                    dismissPicker(pickerViewController!)
//
//                case .failure:
//
//                    LKProgressHUD.showFailure(text: "儲存失敗！")
//                }
//        })
//    }
//}


//class CompareListFlowLayout: UICollectionViewFlowLayout {
//    
//    override var collectionViewContentSize: CGSize {
//        
//        let newSize: CGSize = CGSize(width: 3 * 154, height: 404)
//        return newSize
//    }
//    
//    override var estimatedItemSize: CGSize {
//        
//        let newSize: CGSize = CGSize(width: 154, height: 404)
//        return newSize
//    }
//    
//}



//extension CompareListViewController: UICollectionViewFlowLayout {
//
//}
