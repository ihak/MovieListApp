//
//  MovieSearchResponse.swift
//  MovieListApp
//
//  This class is used to parse and save the response of a search.
//  It also maintains current and next page inforamtion for the result set.
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
    
    func clearResponse() {
        self.page = 0
        self.totalPages = 0
        self.totalResults = 0
        self.results = [Movie]()
    }
    
    func updateResponse(newResponse: MovieSearchResponse) {
        self.page = newResponse.page
        self.totalPages = newResponse.totalPages
        self.totalResults = newResponse.totalResults
        self.results.append(contentsOf: newResponse.results)
    }
}
