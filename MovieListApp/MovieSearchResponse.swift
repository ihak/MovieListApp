//
//  MovieSearchResponse.swift
//  MovieListApp
//
//  Created by Hassan Ahmed on 15/08/2017.
//  Copyright © 2017 Hassan Ahmed. All rights reserved.
//

import Foundation

class MovieSearchResponse {
    var page = 0
    var totalResults = 0
    var totalPages = 0
    var results = [Movie]()
    
    convenience init(dictionary: [String: Any]) {
        self.init()
        
        if let page = dictionary["page"] as? Int {
            self.page = page
        }
        
        if let totalResults = dictionary["total_results"] as? Int {
            self.totalResults = totalResults
        }
        
        if let totalPages = dictionary["total_pages"] as? Int {
            self.totalPages = totalPages
        }
        
        if let results = dictionary["results"] as? [[String : Any]] {
            for result in results {
                self.results.append(Movie(dictionary: result))
            }
        }
    }
}
