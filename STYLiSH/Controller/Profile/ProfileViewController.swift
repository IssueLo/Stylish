//
//  ProfileViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/14.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderTableView.lk_registerCellWithNib(identifier: String(describing: OrderListTableViewCell.self), bundle: nil)
        fetchData() // TODO: 之後要改成打一支 GET api ，把所有購買記錄抓下來
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData() // TODO: 之後要改成打一支 GET api ，把所有購買記錄抓下來
    }

    
    @IBOutlet weak var orderTableView: UITableView! {
        
        didSet {
            orderTableView.delegate = self
            orderTableView.dataSource = self
        }
    
    }
    
    var orders: [LSOrder] = [] {
        
        didSet {
            
            orderTableView.reloadData()
            
            if orders.count == 0 {
                
                orderTableView.isHidden = true
                
            } else {
                
                orderTableView.isHidden = false
                
            }
            
            view.layoutIfNeeded()
        }
    }
    
    
    func fetchData() { // TODO: 之後要改成打一支 GET api ，把所有購買記錄抓下來
        
        StorageManager.shared.fetchOrders(completion: { result in
            
            switch result {
                
            case .success(let orders):
                
                self.orders = orders
                
            case .failure:
                
                LKProgressHUD.showFailure(text: "讀取資料發生錯誤！")
            }
        })
    }
    

    @IBOutlet weak var collectionView: UICollectionView! {

        didSet {

////            collectionView.delegate = self
////            collectionView.dataSource = self
        }
    }

//    let manager = ProfileManager()

}


//extension ProfileViewController: UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//
//        return manager.groups.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return manager.groups[section].items.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: String(describing: ProfileCollectionViewCell.self),
//            for: indexPath
//        )
//
//        guard let profileCell = cell as? ProfileCollectionViewCell else { return cell }
//
//        let item = manager.groups[indexPath.section].items[indexPath.row]
//
//        profileCell.layoutCell(image: item.image, text: item.title)
//
//        return profileCell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        if kind == UICollectionView.elementKindSectionHeader {
//
//            let header = collectionView.dequeueReusableSupplementaryView(
//                ofKind: UICollectionView.elementKindSectionHeader,
//                withReuseIdentifier: String(describing: ProfileCollectionReusableView.self),
//                for: indexPath
//            )
//
//            guard let profileView = header as? ProfileCollectionReusableView else { return header }
//
//            let group = manager.groups[indexPath.section]
//
//            profileView.layoutView(title: group.title, actionText: group.action?.title)
//
//            return profileView
//        }
//
//        return UICollectionReusableView()
//    }
//}
//
//extension ProfileViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        if indexPath.section == 0 {
//
//            return CGSize(width: UIScreen.width / 5.0, height: 60.0)
//
//        } else if indexPath.section == 1 {
//
//            return CGSize(width: UIScreen.width / 4.0, height: 60.0)
//        }
//
//        return CGSize.zero
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 24.0, left: 0, bottom: 0, right: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 24.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        return CGSize(width: UIScreen.width, height: 48.0)
//    }
//}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: OrderListTableViewCell.self),
            for: indexPath
        )
        
        guard let orderCell = cell as? OrderListTableViewCell else { return cell }
        
        orderCell.layoutView(order: orders[indexPath.row])
        
        
        return orderCell
    }
    
    
}
