//
//  ProfileViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/14.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    let orderListProvider = OrderListProvider()
    
    @IBOutlet weak var showEmptyView: UIView!
    
    @IBOutlet weak var logBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showEmptyView.isHidden = true
        
//        showAllBtn.isHidden = true
        
//         註冊 cell
        orderTableView.lk_registerCellWithNib(identifier: String(describing: OrderListTableViewCell.self), bundle: nil)
       
//         註冊 header footer
        let orderHeaderXib = UINib(nibName: OrderListTableHeaderView.identifier, bundle: nil)

        orderTableView.register(orderHeaderXib, forHeaderFooterViewReuseIdentifier: OrderListTableHeaderView.identifier)
        
        let orderFooterXib = UINib(nibName: OrderListTableFooterView.identifier, bundle: nil)
        
        orderTableView.register(orderFooterXib, forHeaderFooterViewReuseIdentifier: OrderListTableFooterView.identifier)

        fetchOrderData()
        fetchUserProfile()
        updateBtn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        orderTableView.reloadData()
        
        fetchOrderData()
        fetchUserProfile()
        updateBtn()
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        KeyChainManager.shared.token = nil
        
        orders = []
        
        orderProfileUserName.text = ""
        
        orderProfileUserID.text = "ID: "
        
        orderTableView.reloadData()
        
        backToRoot(completion: {
            
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            
            let root = appdelegate?.window?.rootViewController as? STTabBarViewController
            
            root?.selectedIndex = 0
        })
        
        LKProgressHUD.showSuccess(text: "登出成功！")
        
        updateBtn()
        
    }
    
    @IBOutlet weak var orderProfileUserName: UILabel!
    
    @IBOutlet weak var orderProfileUserID: UILabel!
    
    @IBOutlet weak var orderTableView: UITableView! {
        
        didSet {
            
            orderTableView.delegate = self
            
            orderTableView.dataSource = self
        }
    
    }
    
    func updateBtn() {
        
        if KeyChainManager.shared.token == nil {
            
            logBtn.isHidden = true
            
        } else {
            
            logBtn.setTitle("登出", for: .normal)
            logBtn.isHidden = false
        }
    }
    
    var profile: UserData = UserData(id: 0, provider: "", name: "", email: "", picture: nil, gender: nil, birth: nil, phone: nil, location: nil)
    
    var orders: [OrderList] = [] {
        
        didSet {
            
            orderTableView.reloadData()
            
            if orders.count == 0 {
                
                orderTableView.isHidden = true
                
                showEmptyView.isHidden = false
    
                
            } else {
                
                orderTableView.isHidden = false
                
                showEmptyView.isHidden = true
                
                print("===== \(orders.count)")
            }
            
            view.layoutIfNeeded()
        }
    }
    
    
    func fetchOrderData() {
        
        orderListProvider.fetchOrderList { [weak self] result in
            
            switch result{
                
            case .success(let orders):
                    
                    self?.orders = orders
                
            case .failure:
                
                LKProgressHUD.showFailure(text: "讀取訂單資料失敗！")
                
            }
        }
    }
    
    func fetchUserProfile() {
        
        orderListProvider.fetchOrderProfile { [weak self] result in
            
            switch result {
                
            case .success(let profile):
                
                self?.profile = profile.data
                
                self?.orderProfileUserName.text = profile.data.name
                
                self?.orderProfileUserID.text = "ID: \(profile.data.id)"
        
                self?.profilePhoto.loadImage(profile.data.picture)
                
            case .failure:
                
                LKProgressHUD.showFailure(text: "讀取會員資料失敗！")
                
            }
        }
    }
    

    @IBOutlet weak var collectionView: UICollectionView! {

        didSet {

////            collectionView.delegate = self
////            collectionView.dataSource = self
        }
    }

//    let manager = ProfileManager()
    
    var tabOnBtn = false
    
    @IBOutlet weak var showAllBtn: UIButton!
    
    @IBAction func showAllOrders(_ sender: Any) {
        
        tabOnBtn = !tabOnBtn
        
        orderTableView.reloadData()
        
        if tabOnBtn {
            
            orderTableView.rowHeight = 0
            showAllBtn.setTitle("展開訂單詳情", for: .normal)
            
        } else {
            
            orderTableView.rowHeight = 75
            showAllBtn.setTitle("收回", for: .normal)
            
        }
        
    }

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
    
    //MARK: - Section Count
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return orders.count
    }
    
    //MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard
            let orderHeaderView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: OrderListTableHeaderView.identifier
                )
                as? OrderListTableHeaderView else {
                    
                    return nil
        }
        
        orderHeaderView.backgroundColor = UIColor.B2
        
        let orderNum = orders[section].number
        
        let orderStatus = orders[section].status
        
        orderHeaderView.orderNO.text = String(orderNum)
        
        orderHeaderView.orderTime.text = orders[section].time
        
        var status = ""
        
        if orderStatus == 0 {
            status = "待出貨"
        } else {
            status = "待付款"
        }
        
        orderHeaderView.orderStatus.text = status
        
        orderHeaderView.orderIndex.text = String(section + 1)
            
        
        
        return orderHeaderView
    }
    
    //MARK: - Section Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return 100.0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard
            let orderFooterView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: OrderListTableFooterView.identifier
                )
                as? OrderListTableFooterView else {
                    
                    return nil
        }
        
        let detail = orders[section].details
        
        orderFooterView.totalPrice.text = String(detail.total)
        orderFooterView.subTotal.text = String(detail.subtotal)
        orderFooterView.freight.text = String(detail.freight)
        orderFooterView.recipientName.text = detail.recipient.name
        orderFooterView.recipientAdd.text = detail.recipient.address
        orderFooterView.recipientTime.text = detail.recipient.time
        orderFooterView.payway.text = detail.payment
        
        return orderFooterView
    }
    
    
     //MARK: - Section cell rows
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orders[section].details.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: OrderListTableViewCell.self),
            for: indexPath
        )
        
        guard let orderCell = cell as? OrderListTableViewCell else { return cell }
        
        let details = orders[indexPath.section].details
        
        let title = details.list[indexPath.row].name
        
        let size = details.list[indexPath.row].size
        
        let price = details.list[indexPath.row].price
        
        let color = details.list[indexPath.row].color
        
        let qtn = details.list[indexPath.row].qty
        
        let productId = details.list[indexPath.row].id
        
        orderCell.selectedQuantity.text = "數量：\(qtn)"
        
        DispatchQueue.main.async {
            orderCell.orderProductImage.loadImage("https://300zombies.com/assets/\(productId)/main.jpg")
        }
        
        orderCell.orderProductBaseView.layoutView(title: title , size: size, price: String(price), color: color)
        
        orderCell.orderProductBaseView.removeBtn.isHidden = true
        
        return orderCell
    }
    
    
}
