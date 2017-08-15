//
//  DBManager.swift
//  MovieListApp
//
//  Created by Hassan Ahmed on 15/08/2017.
//  Copyright © 2017 Hassan Ahmed. All rights reserved.
//

import Foundation
import SQLite

struct SearchQueryTable {
    static let table = Table("search_query")
    static let dbId = Expression<Int64>("id")
    static let searchText = Expression<String>("search_text")
    static let totalResults = Expression<Int>("total_results")
    static let searchCount = Expression<Int>("search_count")
    static let lastSearchedOn = Expression<Int64>("lastSearchedOn")
}

class DBManager {
    static let sharedInstance = DBManager()
    
    private let db: Connection
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/db.sqlite3"
        db = try! Connection(path)
        
        createSearchQueryTable()
    }
    
    private func createSearchQueryTable() {
        
        do {
            try db.run(SearchQueryTable.table.create(ifNotExists: true) { t in
                t.column(SearchQueryTable.dbId, primaryKey: true)
                t.column(SearchQueryTable.searchText)
                t.column(SearchQueryTable.totalResults)
                t.column(SearchQueryTable.searchCount)
                t.column(SearchQueryTable.lastSearchedOn)
            })
        }
        catch {
            print("Couldn't create table: \(SearchQueryTable.table)")
        }
    }
        
    func insert(query: Insert) -> Int64? {
        return try? db.run(query)
    }
    
    func update(query: Update) -> Int? {
        return try? db.run(query)
    }
    
    func delete(query: Delete) -> Int? {
        return try? db.run(query)
    }
    
    func prepare(query: QueryType) -> AnySequence<Row>? {
        return try? db.prepare(query)
    }
    
    func pluck(query: QueryType) -> Row? {
        return try! db.pluck(query)
    }
    
    func scalar(query: ScalarQuery<Int>) -> Any? {
        return try? db.scalar(query)
    }
    
    func scalar(query: String) -> Int64? {
        return try! db.scalar(query) as? Int64
    }
}
