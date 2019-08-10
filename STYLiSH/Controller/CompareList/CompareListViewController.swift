//
//  CompareListViewController.swift
//  STYLiSH
//
//  Created by 戴汝羽 on 2019/8/10.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class CompareListViewController: UIViewController {
    
    @IBOutlet weak var collevtionView: UICollectionView!
    
    var orders: [LSOrder] = [] {
        
        didSet {
            
            collevtionView.reloadData()
            
            if orders.count == 0 {
                
                collevtionView.isHidden = true
                
//                checkoutBtn.isEnabled = false
//
//                checkoutBtn.backgroundColor = UIColor.B4
                
            } else {
                
                collevtionView.isHidden = false
                
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

        collevtionView.lk_registerCellWithNib(identifier: String(describing: CompareListCell.self), bundle: nil)

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
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CompareListCell.self),
            for: indexPath
        )
        
        guard let compareCell = cell as? CompareListCell else { return cell }
        
        return compareCell
        
    }
    
}
