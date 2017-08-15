//
//  SearchQueryRepository.swift
//  MovieListApp
//
//  Created by Hassan Ahmed on 15/08/2017.
//  Copyright © 2017 Hassan Ahmed. All rights reserved.
//

import Foundation
import SQLite

class SearchQueryRepository {
    static func add(query: SearchQuery) -> Int64? {
        let insert = SearchQueryTable.table.insert(
            SearchQueryTable.searchText <- query.searchText,
            SearchQueryTable.searchCount <- query.searchCount,
            SearchQueryTable.totalResults <- query.totalResults,
            SearchQueryTable.lastSearchedOn <- Int64(query.searchDate.timeIntervalSince1970)
        )
        return DBManager.sharedInstance.insert(query: insert)
    }
    
    static func delete(queryId: Int64) -> Int? {
        let filter = SearchQueryTable.table.filter(SearchQueryTable.dbId == queryId)
        return DBManager.sharedInstance.delete(query: filter.delete())
    }
    
    static func update(query: SearchQuery) -> Int? {
        let filter = SearchQueryTable.table.filter(SearchQueryTable.dbId == query.dbId)
        let query = filter.update(
            SearchQueryTable.searchText <- query.searchText,
            SearchQueryTable.searchCount <- query.searchCount,
            SearchQueryTable.totalResults <- query.totalResults,
            SearchQueryTable.lastSearchedOn <- Int64(query.searchDate.timeIntervalSince1970)
        )
        return DBManager.sharedInstance.update(query: query)
    }
    
    static func get(queryId: Int64) -> SearchQuery? {
        var first: SearchQuery?
        let filter = SearchQueryTable.table.filter(SearchQueryTable.dbId == queryId)
        if let row = DBManager.sharedInstance.pluck(query: filter) {
            first = SearchQuery(row: row)
        }
        
        return first
    }
    
    static func getList() -> [SearchQuery] {
        var list = [SearchQuery]()
        let filter = SearchQueryTable.table.filter(SearchQueryTable.totalResults > 0)
        if let rows = DBManager.sharedInstance.prepare(query: filter) {
            for row in rows {
                list.append(SearchQuery(row: row))
            }
        }
        return list
    }
}
