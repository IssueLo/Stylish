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
    
    var orders: [LSOrder] = [] {
        
        didSet {
            
            collectionView.reloadData()
            
            if orders.count == 0 {
                
                collectionView.isHidden = true
                
//                checkoutBtn.isEnabled = false
//
//                checkoutBtn.backgroundColor = UIColor.B4
                
            } else {
                
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
                                                   bottom: UIScreen.height - 468 ,
                                                   right: 16)
        
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        StorageManager.shared.saveAll(completion: { _ in })
    }
    
    //MARK: - Action
    
    func fetchData() {
        
        StorageManager.shared.fetchOrders(completion: { result in
            
            switch result {
                
            case .success(let orders):
                
                self.orders = orders
                
            case .failure:
                
                LKProgressHUD.showFailure(text: "讀取資料發生錯誤！")
            }
        })
    }
    
    func deleteData(at index: Int) {
        
        StorageManager.shared.deleteOrder(
            orders[index],
            completion: { result in
                
                switch result {
                    
                case .success:
                    
                    orders.remove(at: index)
                    
                case .failure:
                    
                    LKProgressHUD.showFailure(text: "刪除資料失敗！")
                }
        })
    }

}

extension CompareListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(orders.count)
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CompareListCell.self),
            for: indexPath
        )
        
        guard let compareCell = cell as? CompareListCell else { return cell }
        
        compareCell.titleLabel.text = orders[indexPath.row].seletedColor
        
        return compareCell
        
    }
    
}

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
