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
    
    let marketProvider = MarketProvider()
    
    @IBOutlet weak var tableView: UITableView!
    
//    var dataArray = [String]()
    
    var searchedArray = [Product]()
    
    var shouldShowSearchResults = false
    
    var allProductDatas: [Product] = [] {
        didSet {
//            tableView.reloadData()
        }
    }
    
    var paging: Int? = nil
    
    var searchController: UISearchController!

    @IBAction func goBackPage(_ sender: UIBarButtonItem) {
        
        shouldShowSearchResults = false
        
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cpdSetupTableView()
        
        setupTableView()
        
        getAllProductData()
        
        setUpSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateTable()
    }
    
    private func cpdSetupTableView() {
        
        if tableView == nil {
            
            let tableView = UITableView()
            
            view.stickSubView(tableView)
            
            self.tableView = tableView
        }
        
        tableView.dataSource = self
        
        tableView.delegate = self
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
        
        if shouldShowSearchResults {
            
            return searchedArray.count
            
        } else {
        
            return allProductDatas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ProductTableViewCell.self),
            for: indexPath
        )
        
        guard let productCell = cell as? ProductTableViewCell else { return cell }
        
        if shouldShowSearchResults {
            
            guard let product = searchedArray[indexPath.row] as? Product else { return cell }
            
            productCell.layoutCell(
                image: product.mainImage,
                title: product.title,
                price: product.price
            )
            
        } else {
            
            guard let product = allProductDatas[indexPath.row] as? Product else { return cell }
            
            productCell.layoutCell(
                image: product.mainImage,
                title: product.title,
                price: product.price
            )
        }
        
        return productCell
    }
    
    
//    animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
//    cell.transform = CGAffineTransformMakeTranslation(0, 0);
//    }, completion: nil)
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index),usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .init(), animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            
            index += 1
        }
    }
    
//    func getAllProductData() {
//
//        var provider: ProductListDataProvider?
//
//        let productTypeArray = [ ProductsProvider.ProductType.women,
//                                 ProductsProvider.ProductType.men,
//                                 ProductsProvider.ProductType.accessories ]
//
//        let group = DispatchGroup()
//
//        for productType in productTypeArray {
//
//            group.enter()
//
//            provider = ProductsProvider(productType: productType,
//                                        dataProvider: marketProvider)
//
//            provider?.fetchData(paging: 0, completion: { [weak self] result in
//
//                switch result {
//
//                case .success(let response):
//
//                    self?.allProductDatas += response.data
//
//                    print(self?.allProductDatas.count as Any)
//
//                    group.leave()
//
//                    //                    self?.paging = response.paging
//
//                case .failure(let error):
//
//                    LKProgressHUD.showFailure(text: error.localizedDescription)
//                }
//            })
//        }
//
//        group.notify(queue: .main) {
//
//            self.tableView.reloadData()
//        }
//    }
    
    // MARK: 請叫我 DispatchGroup 天才
    func getAllProductData() {

        var provider: ProductListDataProvider?

        let productTypeArray = [ ProductsProvider.ProductType.women,
                                 ProductsProvider.ProductType.men,
                                 ProductsProvider.ProductType.accessories ]

        let group = DispatchGroup()

        for productType in productTypeArray {

            group.enter()

            fetchData(0, productType, group)
            
        }

        group.notify(queue: .main) {

            self.tableView.reloadData()
        }
    }
    
    func fetchData(_ paging: Int?, _ productType: ProductsProvider.ProductType, _ group: DispatchGroup) {
        
        if paging != nil {
            
            let provider = ProductsProvider(productType: productType,
                                        dataProvider: marketProvider)
            
            provider.fetchData(paging: paging!, completion: { [weak self] result in
                
                switch result {
                    
                case .success(let response):
                    
                    self?.allProductDatas += response.data
                    
                    print(self?.allProductDatas.count as Any)
                                        
                    self?.fetchData(response.paging, productType, group)
                    
                case .failure(let error):
                    
                    LKProgressHUD.showFailure(text: error.localizedDescription)
                }
            })
            
        } else {
            
            group.leave()
            
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard
            let product = allProductDatas[indexPath.row] as? Product
        else { return }
        
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
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    func setUpSearchBar() {
        
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
        
        definesPresentationContext = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
        
        print("SearchButtonClicked")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
        
        print("TextDidBeginEditing")
        //        self.dismiss(animated: true, completion: nil)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
        
        print("CancelButtonClicked")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchString = searchController.searchBar.text!
        
        searchedArray = allProductDatas.filter({ (proudct) -> Bool in
            
            return proudct.title.contains(searchString)
        })
        
        tableView.reloadData()
    }
//
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        guard let searchString = searchController.searchBar.text else {
//            return
//        }
//
//        // Filter the data array and get only those countries that match the search text.
//        filteredArray = dataArray.filter({ (country) -> Bool in
//            let countryText:NSString = country
//
//            return (countryText.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
//        })
//
//        // Reload the tableview.
//        tblSearchResults.reloadData()
//    }
    
}
