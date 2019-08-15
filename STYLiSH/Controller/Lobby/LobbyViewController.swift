//
//  LobbyViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class LobbyViewController: STBaseViewController {
    
    // MARK: Add by Kevin
    @IBOutlet weak var logoImage: UIImageView!
    
    func logoImageAnimate() {
        
        UIView.animate(withDuration: 3) {
            self.logoImage.alpha = 0
        }
    }
    
    @IBOutlet weak var lobbyView: LobbyView! {

        didSet {

            lobbyView.delegate = self
        }
    }

    var datas: [PromotedProducts] = [] {

        didSet {
            
            lobbyView.reloadData()
        }
    }

    let marketProvider = MarketProvider()

    //MARK: - View Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        logoImageAnimate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = UIImageView(image: UIImage.asset(.Image_Logo02))
        
        lobbyView.beginHeaderRefresh()
    }

    //MARK: - Action
    func fetchData() {
        
        marketProvider.fetchHots(completion: { [weak self] result in

            switch result {

            case .success(let products):

                self?.datas = products

            case .failure:

                LKProgressHUD.showFailure(text: "讀取資料失敗！")
            }
        })
    }
}

extension LobbyViewController: LobbyViewDelegate {
    
    func triggerRefresh(_ lobbyView: LobbyView) {
        
        fetchData()
    }

    //MARK - UITableViewDataSource and UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {

        return datas.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return datas[section].products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: LobbyTableViewCell.self),
            for: indexPath
        )

        guard let lobbyCell = cell as? LobbyTableViewCell else { return cell }

        let product = datas[indexPath.section].products[indexPath.row]

        if indexPath.row % 2 == 0 {

            lobbyCell.singlePage(
                img: product.mainImage,
                title: product.title,
                description: product.description
            )

        } else {

            lobbyCell.multiplePages(
                imgs: product.images,
                title: product.title,
                description: product.description
            )
        }

        return lobbyCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 67.0 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 258.0 }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 0.01 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView
            .dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: LobbyTableViewHeaderView.self)
            ) as? LobbyTableViewHeaderView else {
                return nil
        }
        
        headerView.titleLabel.text = datas[section].title
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let detailVC = UIStoryboard
            .product
            .instantiateViewController(
                withIdentifier: String(describing: ProductDetailViewController.self)
            ) as? ProductDetailViewController else {
                
                return
        }
        
        detailVC.product = datas[indexPath.section].products[indexPath.row]
        
        show(detailVC, sender: nil)
    }
}
