//
//  ViewController.swift
//  MovieListApp
//
//  Created by Hassan Ahmed on 15/08/2017.
//  Copyright © 2017 Hassan Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let CellIdentifier = "MovieListCell"
    var ihakTableRefresh: iHAKTableRefresh!
    
    let searchController = UISearchController(searchResultsController: nil)

    var searchResponse = MovieSearchResponse()
    
    var searchSuggestionVC: SearchSuggestionVC!
    
    var isSearching = false {
        willSet {
            if newValue == true {
                addSearchSuggestionVC()
            }
            else {
                removeSearchSuggestionVC()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set tableview height to be dynamic
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set estimated row height allow tableview to approximate scroll indicator
        self.tableView.estimatedRowHeight = 66
        
        // Initialize table refresh control
        ihakTableRefresh = iHAKTableRefresh(tableView: tableView, refreshType: .TopAndBottom, delegate: self, dataSource: nil)
        
        // Set search controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     Fetch latest records
    */
    func performSearch() {
        if let text = self.searchController.searchBar.text {
            guard text.isEmpty == false else {
                return
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            APIClient.getSearchResults(withSearchText: text, forPage: self.searchResponse.page+1) { (error, response) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if error != nil {
                    showAlert(title: "", message: error!.localizedDescription, viewController: self)
                    self.ihakTableRefresh.finishRefresh(success: false)
                }
                else {
                    self.ihakTableRefresh.finishRefresh(success: true)
                    self.searchResponse.updateResponse(newResponse:response)
                    self.tableView.reloadData()
                    
                    // Prepare the SearchQuery object to be saved in the db
                    let sq = SearchQuery()
                    sq.searchText = text
                    sq.totalResults = self.searchResponse.totalResults
                    let _ = SearchQueryRepository.add(query: sq)
                    
                    if self.searchResponse.totalResults <= 0 {
                        showAlert(title: "Error", message: "No results found.", viewController: self)
                    }
                }
            }
        }
    }
    
    /**
     Filter search results upon text change
     */
    func suggestSearch() {
        if let text = self.searchController.searchBar.text {
            if let _ = self.searchSuggestionVC {
                self.searchSuggestionVC.search(text: text)
            }
        }
    }
    
    /**
     Add SearchSuggestionVC
     */
    func addSearchSuggestionVC() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kSearchSuggestionVC) as? SearchSuggestionVC {
            self.searchSuggestionVC = vc
            self.searchSuggestionVC.delegate = self
            
            self.addChildViewController(self.searchSuggestionVC)
            
            let topLayoutGuide = self.topLayoutGuide
            let view = self.searchSuggestionVC.view!
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:|-(64)-[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view, "topLayoutGuide": topLayoutGuide]))
        }
    }

    /**
     Remove SearchSuggestionVC
     */
    func removeSearchSuggestionVC() {
        if let _ = self.searchSuggestionVC {
            self.searchSuggestionVC.view.removeFromSuperview()
            self.searchSuggestionVC.removeFromParentViewController()
            self.searchSuggestionVC = nil
        }
    }
}

//MARK: - Extension - Implements UITableViewDataSource and UITableViewDelegate methods

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! MovieListCell
        let movie = self.searchResponse.results[indexPath.row]
        cell.model = movie
        
        return cell
    }
}

//MARK: - Extension - Implements iHAKTableRefreshDataSource

extension ViewController: iHAKTableRefreshDataSource, iHAKTableRefreshDelegate {
    /**
     Implement this method to perform any data refresh on the tableview in case of top refresh.
     */
    func iHAKTableRefreshWillPerformTopRefresh(refreshView: iHAKTableRefresh) {
        // clear already fetched results and perform a fresh search
        self.searchResponse.clearResponse()
        self.tableView.reloadData()
        performSearch()
    }
    
    /**
     Implement this method to perform any data refresh on tableview in case of bottom refresh.
     */
    func iHAKTableRefreshWillPerformBottomRefresh(refreshView: iHAKTableRefresh) {
        performSearch()
    }
    
    /**
     Implement this method if you want to control when to refresh your view.
     Return false if you don't want top refresh. This method is not get called if
     the property topViewEnabled is false.
     */
    func iHAKTableRefreshShouldPerformTopRefresh(refreshView: iHAKTableRefresh) -> Bool {
        if let isEmpty = searchController.searchBar.text?.isEmpty {
            return !isEmpty
        }
        
        return true
    }
    
    /**
     Implement this method if you want to control when to refresh your view.
     Return false if you don't want bottom refresh. This method is not get called if
     the property bottomViewEnabled is false.
     */
    func iHAKTableRefreshShouldPerformBottomRefresh(refreshView: iHAKTableRefresh) -> Bool {
        return self.searchResponse.page < self.searchResponse.totalPages
    }
}


//MARK: - Extension - Implements UISearchResultsUpdating

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Search interaction has ended and new result is being fetched
        self.isSearching = false

        // clear the previous results and perform new search
        self.searchResponse.clearResponse()
        self.tableView.reloadData()
        performSearch()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Clear the previous results
        self.searchResponse = MovieSearchResponse()
        self.tableView.reloadData()
        
        self.isSearching = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Search interaction has started
        self.isSearching = true
        
        // Suggest search quries from local db
        suggestSearch()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // update the search quries filtered by search text
        suggestSearch()
        print("\(String(describing: searchController.searchBar.text))")
    }
}

//MARK: - Extension - Implements SearchSuggestionDelegate

extension ViewController: SearchSuggestionDelegate {
    func searchSuggestionVC(vc: SearchSuggestionVC, didSelectSearchQuery: SearchQuery) {
        self.searchController.searchBar.text = didSelectSearchQuery.searchText
        self.searchController.searchBar.resignFirstResponder()
        
        // Clear the previous results
        self.searchResponse = MovieSearchResponse()
        self.tableView.reloadData()

        performSearch()
        self.isSearching = false
    }
}
