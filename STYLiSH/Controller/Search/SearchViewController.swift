//
//  SearchViewController.swift
//  STYLiSH
//
//  Created by 戴汝羽 on 2019/8/13.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit
//, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating
class SearchViewController: UIViewController {

    @IBAction func goBackPage(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        self.dismiss(animated: true, completion: nil)
        
    }
    var searchController: UISearchController!
    @IBOutlet weak var search: UIBarButtonItem! {
        didSet {
            //            search.image = UISearchBar.Icon.search.self
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.prefersLargeTitles = true
//        
//        self.searchController = UISearchController(searchResultsController:  nil)
//        
//        self.searchController.searchResultsUpdater = self
//        self.searchController.delegate = self
//        self.searchController.searchBar.delegate = self
//        
//        self.searchController.hidesNavigationBarDuringPresentation = false
//        self.searchController.dimsBackgroundDuringPresentation = false
//        self.searchController.obscuresBackgroundDuringPresentation = false
//        
//        navigationItem.searchController = searchController
//        navigationItem.searchController?.searchBar.placeholder = true
//        
//        searchController.searchBar.showsCancelButton = false
//        navigationItem.hidesSearchBarWhenScrolling = false
//        searchController.searchBar.isHidden = true
//        
//        headerView.addSubview(searchController.searchBar)
//        open var hidesSearchBarWhenScrolling: Bool
//        
//        searchController.searchBar.sizeToFit()
//        
//        definesPresentationContext = true
//        
//        searchController.searchBar.becomeFirstResponder()
//        
//        navigationItem.titleView = searchController.searchBar
//        
//        navigationItem.title = "型錄"
//        
//        searchController.searchBar.placeholder = "Search here..."
//        
//        navigationItem.hidesSearchBarWhenScrolling = true
//        
//        searchView2 = searchController.searchBar
//        
//        self.navigationItem.leftBarButtonItem?.customView = searchController.searchBar
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
