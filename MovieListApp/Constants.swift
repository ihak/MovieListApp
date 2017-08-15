//
//  Constants.swift
//  MovieListApp
//
//  Created by Hassan Ahmed on 15/08/2017.
//  Copyright © 2017 Hassan Ahmed. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Segues

// MARK: - Storyboard IDs
let kSearchSuggestionVC = "SearchSuggestionVC"

//MARK: - Others
func showAlert(title: String, message: String, viewController: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    viewController.present(alertController, animated: true, completion: nil)
}
