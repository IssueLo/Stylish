//
//  TestViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/7/26.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class CheckoutViewController: STBaseViewController {
    
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
        
        return vc
    }()
    
    var isCanGetPrime: Bool = false
    
    private let userProvider = UserProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    //TODO
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
        
        return inputCell
    }
}

extension CheckoutViewController: STPaymentInfoTableViewCellDelegate {
    
    func didChangePaymentMethod(_ cell: STPaymentInfoTableViewCell) {
        
        tableView.reloadData()
    }
    
    func didChangeUserData(
        _ cell: STPaymentInfoTableViewCell,
        payment: String,
        cardNumber: String,
        dueDate: String,
        verifyCode: String
    ) {
        
    }
    
    func checkout(_ cell: STPaymentInfoTableViewCell) {
        
        guard tappayVC.isCanGetPrime == true else { return }
        
        tappayVC.getPrime(completion: { [weak self] result in
            
            switch result{
                
            case .success(let prime):
                
                self?.userProvider.checkout(prime: prime, completion: { result in
                    
                    switch result{
                        
                    case .success(let reciept):
                        
                        print(reciept)
                        
                    case .failure(let error):
                        
                        //TODO
                        print(error)
                    }
                })
                
            case .failure(let error):
                //TODO
                
                print(error)
            }
        })
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
    
        print(orderProvider.order.reciever)
    }
}
