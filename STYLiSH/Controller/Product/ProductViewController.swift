//
//  ProductViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/15.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    private enum LayoutType {

        case list

        case grid
    }

    private enum ProductType: Int {

        case women = 0

        case men = 1

        case accessories = 2
    }

    private struct Segue {

        static let men = "SegueMen"

        static let women = "SegueWomen"

        static let accessories = "SegueAccessories"
    }

    @IBOutlet weak var indicatorView: UIView!

    @IBOutlet weak var indicatorCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var layoutBtn: UIBarButtonItem!

    @IBOutlet weak var menProductsContainerView: UIView!

    @IBOutlet weak var womenProductsContainerView: UIView!

    @IBOutlet weak var accessoriesProductsContainerView: UIView!

    @IBOutlet var productBtns: [UIButton]!

    var containerViews: [UIView] {

        return [menProductsContainerView, womenProductsContainerView, accessoriesProductsContainerView]
    }

    var isListLayout: Bool = true {

        didSet {

            switch isListLayout {

            case true: showListLayout()

            case false: showGridLayout()

            }
        }
    }
    
    var searchController: UISearchController!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchView2: UIView!
    
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

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        isListLayout = true
        
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        
        searchController.searchBar.placeholder = "Search here..."
        
        searchController.searchBar.sizeToFit()
        
        definesPresentationContext = true
        
        searchController.searchBar.becomeFirstResponder()
//        tblSearchResults.tableHeaderView = searchController.searchBa
        
//        searchView2 = searchController.searchBar
        
//        self.navigationItem.leftBarButtonItem?.customView = searchController.searchBar
//        self.navigationItem.titleView = searchController.searchBar
    }

    // MARK: - Action
    @IBAction func onChangeProducts(_ sender: UIButton) {

        for btn in productBtns {

            btn.isSelected = false
        }

        sender.isSelected = true

        moveIndicatorView(reference: sender)

        guard let type = ProductType(rawValue: sender.tag) else { return }

        updateContainer(type: type)
    }

    @IBAction func onChangeLayoutType(_ sender: UIBarButtonItem) {

        isListLayout = !isListLayout
    }
    
    // MARK: Kevin- Add Btn for compareL
    @IBAction func toCompareList(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "CompareList", bundle: nil)
        
        if let controller = storyboard.instantiateViewController(withIdentifier: "CompareList") as? UINavigationController {
            
            present(controller, animated: true, completion: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let vc = segue.destination as? ProductListViewController else { return }

        let identifier = segue.identifier

        var provider: ProductListDataProvider?

        let marketProvider = MarketProvider()

        if identifier == Segue.men {

            provider = ProductsProvider(productType: ProductsProvider.ProductType.men, dataProvider: marketProvider)

        } else if identifier == Segue.women {

            provider = ProductsProvider(productType: ProductsProvider.ProductType.women, dataProvider: marketProvider)

        } else if identifier == Segue.accessories {

            provider = ProductsProvider(
                productType: ProductsProvider.ProductType.accessories,
                dataProvider: marketProvider
            )
        }

        vc.provider = provider
    }

    // MARK: - Private method
    private func showListLayout() {

        layoutBtn.image = UIImage.asset(.Icons_24px_CollectionView)

        showLayout(type: .list)
    }

    private func showGridLayout() {

        layoutBtn.image = UIImage.asset(.Icons_24px_ListView)

        showLayout(type: .grid)
    }

    private func showLayout(type: LayoutType) {

        children.forEach({ child in

            if let child = child as? ProductListViewController {

                switch type {

                case .list: child.showListView()

                case .grid: child.showGridView()

                }
            }
        })
    }

    private func moveIndicatorView(reference: UIView) {

        indicatorCenterXConstraint.isActive = false

        indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: reference.centerXAnchor)

        indicatorCenterXConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in

            self?.view.layoutIfNeeded()
        })
    }

    private func updateContainer(type: ProductType) {

        containerViews.forEach({ $0.isHidden = true })

        switch type {

        case .men:
            menProductsContainerView.isHidden = false

        case .women:
            womenProductsContainerView.isHidden = false

        case .accessories:
            accessoriesProductsContainerView.isHidden = false

        }
    }
}
