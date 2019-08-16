//
//  TestViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/7/26.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class CheckoutViewController: STBaseViewController {
    
    private struct Segue {
        
        static let success = "SegueSuccess"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var orderProvider: OrderProvider! {
        
        didSet {
            
            guard orderProvider != nil else {
                
                tableView.dataSource = nil
                
                tableView.delegate = nil
            
                return
            }
            
            setupTableView()
        }
    }
    
    lazy var tappayVC: STTapPayViewController = {
        
        let vc = UIStoryboard.trolley.instantiateViewController(withIdentifier: STTapPayViewController.identifier) as! STTapPayViewController
        
        addChild(vc)
        
        vc.loadViewIfNeeded()
        
        vc.didMove(toParent: self)
        
        vc.cardStatusHandler = { [weak self] flag in
            
            self?.isCanGetPrime = flag
        }
        
        return vc
    }()
    
    var isCanGetPrime: Bool = false {
        
        didSet {
        
            updateCheckoutButton()
        }
    }
    
    private let userProvider = UserProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ORDER長這樣")
        print(orderProvider.order)
        
    }
    
    private func setupTableView() {
        
        guard orderProvider != nil else { return }
        
        loadViewIfNeeded()
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        tableView.lk_registerCellWithNib(identifier: STOrderProductCell.identifier, bundle: nil)
        
        tableView.lk_registerCellWithNib(identifier: STOrderUserInputCell.identifier, bundle: nil)
        
        tableView.lk_registerCellWithNib(identifier: STPaymentInfoTableViewCell.identifier, bundle: nil)
        
        let headerXib = UINib(nibName: STOrderHeaderView.identifier, bundle: nil)
        
        tableView.register(headerXib, forHeaderFooterViewReuseIdentifier: STOrderHeaderView.identifier)
    }
    
    //MARK: - Action
    
    func checkout(_ cell: STPaymentInfoTableViewCell) {
        
        guard canCheckout() == true else { return }
        
        guard KeyChainManager.shared.token != nil else {
            
            return onShowLogin()
        }
        
        switch orderProvider.order.payment {
            
        case .credit: checkoutWithTapPay()
            
        case .cash: checkoutWithCash()
            
        }
    }
    
    func onShowLogin() {
        
        guard let vc = UIStoryboard.auth.instantiateInitialViewController() else { return }
        
        vc.modalPresentationStyle = .overCurrentContext
        
        present(vc, animated: false, completion: nil)
    }
    
    private func checkoutWithCash() {
        
        StorageManager.shared.deleteAllProduct(completion: { _ in })
        
        // TODO: 要在這裡打 API 儲存訂單資訊(貨到付款) -> 改成在 ProfileVC 打 API
        
        performSegue(withIdentifier: Segue.success, sender: nil)
    }
    
    private func checkoutWithTapPay() {
        
        LKProgressHUD.show()
        
        tappayVC.getPrime(completion: { [weak self] result in
            
            switch result{
                
            case .success(let prime):
                
                guard let strongSelf = self else { return }
                
                self?.userProvider.checkout(
                    order: strongSelf.orderProvider.order,
                    prime: prime,
                    completion: { result in
                    
                        LKProgressHUD.dismiss()
                        
                        switch result{
                            
                        case .success(let reciept):
                            
                            print(reciept)
                            
                            self?.performSegue(withIdentifier: Segue.success, sender: nil)
                            
                            StorageManager.shared.deleteAllProduct(completion: { _ in })
                            
                            
                        case .failure(let error):
                            
                            //TODO
                            print("＝＝＝＝＝結帳失敗========")
                            print(error)
                        }
                })
                
            case .failure(let error):
                
                LKProgressHUD.dismiss()
                //TODO
                print(error)
            }
        })
        
        // TODO: 要在這裡打 API 儲存訂單資訊 (信用卡)/ 或寫一個 function 把過程包在裡面，放這裡 and checkoutWithCash() -> 改成在 ProfileVC 打 API

    }
    
    func canCheckout() -> Bool {
        
        switch orderProvider.order.payment {
            
        case .cash: return orderProvider.order.isReady()
            
        case .credit: return orderProvider.order.isReady() && isCanGetPrime
            
        }
    }
}

extension CheckoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Section Count
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return orderProvider.orderCustructor.count
    }
    
    //MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 67.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard
            let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: STOrderHeaderView.identifier
            )
        as? STOrderHeaderView else {
            
            return nil
        }
        
        headerView.titleLabel.text = orderProvider.orderCustructor[section].rawValue
        
        return headerView
    }
    
    //MARK: - Section Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return String.empty
    }
    
    

    //MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch orderProvider.orderCustructor[section] {
            
        case .products: return orderProvider.order.products.count
            
        default: return 1
        
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch orderProvider.orderCustructor[indexPath.section] {
            
        case .products:
            
            return mappingCellWtih(order: orderProvider.order, at: indexPath)
            
        case .paymentInfo:
            
            return mappingCellWtih(payment: "", at: indexPath)
            
        case .reciever:
            
            return mappingCellWtih(reciever: orderProvider.order.reciever, at: indexPath)
        }
    }
    
    //MARK: - Layout Cell
    private func mappingCellWtih(order: Order, at indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let orderCell = tableView.dequeueReusableCell(
                withIdentifier: STOrderProductCell.identifier,
                for: indexPath
            ) as? STOrderProductCell
        else {
                
                return UITableViewCell()
        }
        
        let order = orderProvider.order.products[indexPath.row]
        
        orderCell.layoutCell(
            imageUrl: order.product?.images?[0],
            title: order.product?.title,
            color: order.seletedColor,
            size: order.seletedSize,
            price: String(order.product!.price),
            pieces: String(order.amount)
        )
        
        return orderCell
    }
    
    private func mappingCellWtih(reciever: Reciever, at indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let inputCell = tableView.dequeueReusableCell(
                withIdentifier: STOrderUserInputCell.identifier,
                for: indexPath
            ) as? STOrderUserInputCell
        else {
                
                return UITableViewCell()
        }
        
        inputCell.layoutCell(
            name: reciever.name,
            email: reciever.email,
            phone: reciever.phoneNumber,
            address: reciever.address
        )
        
        inputCell.delegate = self
        
        return inputCell
    }
    
    private func mappingCellWtih(payment: String, at indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let inputCell = tableView.dequeueReusableCell(
                withIdentifier: STPaymentInfoTableViewCell.identifier,
                for: indexPath
            ) as? STPaymentInfoTableViewCell
        else {
                
                return UITableViewCell()
        }
        
        inputCell.creditView.stickSubView(tappayVC.view)
        
        inputCell.delegate = self
        
        inputCell.layoutCellWith(
            productPrice: orderProvider.order.productPrices,
            shipPrice: orderProvider.order.freight,
            productCount: orderProvider.order.amount,
            payment: orderProvider.order.payment.rawValue,
            isCheckoutEnable: canCheckout()
        )
        
        inputCell.checkoutBtn.isEnabled = canCheckout()
        
        return inputCell
    }
    
    func updateCheckoutButton() {
        
        guard
            let index = orderProvider.orderCustructor.firstIndex(of: .paymentInfo),
            let cell = tableView.cellForRow(
                at: IndexPath(row: 0, section: index)
            ) as? STPaymentInfoTableViewCell
        else {
            
            return
        }
        
        cell.updateCheckouttButton(isEnable: canCheckout())
    }
}

extension CheckoutViewController: STPaymentInfoTableViewCellDelegate {
    
    func endEditing(_ cell: STPaymentInfoTableViewCell) {
        
        tableView.reloadData()
    }
    
    func didChangePaymentMethod(_ cell: STPaymentInfoTableViewCell, index: Int) {
        
        orderProvider.order.payment = orderProvider.payments[index]
        
        updateCheckoutButton()
    }
    
    func textsForPickerView(_ cell: STPaymentInfoTableViewCell) -> [String] {
        
        return orderProvider.payments.map{ $0.rawValue }
    }
    
    func isHidden(_ cell: STPaymentInfoTableViewCell, at index: Int) -> Bool {
        
        switch orderProvider.payments[index] {
            
        case .cash: return true
            
        case .credit: return false
            
        }
    }
    
    func heightForConstraint(_ cell: STPaymentInfoTableViewCell, at index: Int) -> CGFloat {
        
        switch orderProvider.payments[index] {
        
        case .cash: return 44
        
        case .credit: return 118
            
        }
    }
}

extension CheckoutViewController: STOrderUserInputCellDelegate {
    
    func didChangeUserData(
        _ cell: STOrderUserInputCell,
        username: String,
        email: String,
        phoneNumber: String,
        address: String,
        shipTime: String
    ) {
        
        let newReciever = Reciever(
            name: username,
            email: email,
            phoneNumber: phoneNumber,
            address: address,
            shipTime: shipTime
        )
        
        orderProvider.order.reciever = newReciever
        
        updateCheckoutButton()
    }
}
