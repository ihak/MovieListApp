//
//  SearchSuggestionVC.swift
//  MovieListApp
//
//  Created by Hassan Ahmed Khan on 8/15/17.
//  Copyright © 2017 Hassan Ahmed. All rights reserved.
//

import UIKit

protocol SearchSuggestionDelegate {
    func searchSuggestionVC(vc: SearchSuggestionVC, didSelectSearchQuery: SearchQuery);
}


class SearchSuggestionVC: UIViewController {

    let CellIdentifier = "CellIdentifier"
    
    var searchQueries = [SearchQuery]()
    var delegate: SearchSuggestionDelegate?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Register cell to tableview
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(text: String) {
        self.searchQueries = SearchQueryRepository.getList(matching: text)
        self.tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Extension - Implements UITableViewDelegate UITableViewDataSource
extension SearchSuggestionVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchQueries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)!
        let query = searchQueries[indexPath.row]
        
        cell.textLabel?.text = query.searchText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let query = searchQueries[indexPath.row]
        
        // Call delegate method upon selection
        self.delegate?.searchSuggestionVC(vc: self, didSelectSearchQuery: query)
    }
}
