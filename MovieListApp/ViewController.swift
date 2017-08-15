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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set tableview height to be dynamic
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set estimated row height allow tableview to approximate scroll indicator
        self.tableView.estimatedRowHeight = 66
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

/**
 Extension - Implements UITableViewDataSource and UITableViewDelegate methods
 */

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! MovieListCell
        
        return cell
    }
}

