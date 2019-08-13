//
//  SearchViewController.swift
//  STYLiSH
//
//  Created by 戴汝羽 on 2019/8/13.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit
// UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating
class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var datas: [[Any]] = [[]] {
        
        didSet {
//            reloadData()
        }
    }
    
    var searchController: UISearchController!

    @IBAction func goBackPage(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cpdSetupTableView()
        
        setupTableView()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchResultsUpdater = self
        
        searchController.searchBar.placeholder = "Search here..."
        
        searchController.searchBar.sizeToFit()
        
        navigationItem.titleView = searchController.searchBar

//        self.searchController.searchBar.delegate = self
//
//        definesPresentationContext = true
//        
//        searchController.searchBar.becomeFirstResponder()
//        
//        navigationItem.hidesSearchBarWhenScrolling = true
        
    }
    
    private func cpdSetupTableView() {
        
        if tableView == nil {
            
            let tableView = UITableView()
            
            view.stickSubView(tableView)
            
            self.tableView = tableView
        }
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        //        tableView.addRefreshHeader(refreshingBlock: { [weak self] in
        //
        //            self?.headerLoader()
        //        })
        //
        //        tableView.addRefreshFooter(refreshingBlock: { [weak self] in
        //
        //            self?.footerLoader()
        //        })
    }
    
    private func setupTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor.white
        
        tableView.lk_registerCellWithNib(
            identifier: String(describing: ProductTableViewCell.self),
            bundle: nil
        )
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ProductTableViewCell.self),
            for: indexPath
        )
        
        guard let productCell = cell as? ProductTableViewCell
//            let product = datas[indexPath.section][indexPath.row] as? Product
            else {
                
                return cell
        }
        
//        productCell.layoutCell(
//            image: product.mainImage,
//            title: product.title,
//            price: product.price
//        )
        
        return productCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let product = datas[indexPath.section][indexPath.row] as? Product else { return }
        
        showProductDetailViewController(product: product)
    }
    
    private func showProductDetailViewController(product: Product) {
        
        let vc = UIStoryboard.product.instantiateViewController(withIdentifier:
            String(describing: ProductDetailViewController.self)
        )
        
        guard let detailVC = vc as? ProductDetailViewController else { return }
        
        detailVC.product = product
        
        show(detailVC, sender: nil)
    }
    
}

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        self.dismiss(animated: true, completion: nil)
        
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let text = searchController.searchBar.text else { return }
        
        print(text)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("updating")
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
}
