//
//  SearchQuery.swift
//  MovieListApp
//
//  This Class is used to hold search quries made by user.
//  The queries are then saved in the db and later retrieved.
//
//  Created by Hassan Ahmed on 15/08/2017.
//  Copyright © 2017 Hassan Ahmed. All rights reserved.
//

import Foundation
import SQLite

class SearchQuery {
    var dbId = Int64(-1)
    var searchText = ""
    var totalResults = 0
    var searchCount = 0
    var searchDate = Date(timeIntervalSince1970: 0.0)
    
    convenience init(row: Row) {
        self.init()
        
        self.dbId = row[SearchQueryTable.dbId]
        self.searchText = row[SearchQueryTable.searchText]
        self.totalResults = row[SearchQueryTable.totalResults]
        self.searchCount = row[SearchQueryTable.searchCount]
        
        self.searchDate = Date(timeIntervalSince1970: TimeInterval(row[SearchQueryTable.lastSearchedOn]))
    }
}
