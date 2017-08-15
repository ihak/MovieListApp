//
//  MovieListAppTests.swift
//  MovieListAppTests
//
//  Created by Hassan Ahmed on 15/08/2017.
//  Copyright © 2017 Hassan Ahmed. All rights reserved.
//

import XCTest
@testable import MovieListApp

class MovieListAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchAPI() {
        let expectation = self.expectation(description: "SearchAPITest")
        
        APIClient.getSearchResults(withSearchText: "batman", forPage: 1) { (error, response) in
            if response.results.count > 0 {
                expectation.fulfill()
            }
        }
        
        self.wait(for: [expectation], timeout: 30)
    }
    
    func testSearchQueryDBAdd() {
        let query = SearchQuery()
        query.searchCount = 10
        query.searchText = "inception"
        query.totalResults = 45
        
        XCTAssertNotNil(SearchQueryRepository.add(query: query))
    }
    
    func testSearchQueryDBUpdate() {
        let query = SearchQuery()
        query.dbId = 3
        query.searchCount = 20
        query.searchText = "inception"
        query.totalResults = 95
        
        if let value = SearchQueryRepository.update(query: query) {
            XCTAssertGreaterThan(value, 0)
        }
        else {
            XCTFail()
        }
    }
    
    func testSearchQueryDBDelete() {
        if let value = SearchQueryRepository.delete(queryId: Int64(1)) {
            XCTAssertGreaterThan(value, 0)
        }
        else {
            XCTFail()
        }
    }
    
    func testSearchQueryDBGet() {
        XCTAssertNotNil(SearchQueryRepository.get(queryId: Int64(2)))
    }
    
    func testSearchQueryDBList() {
        XCTAssertGreaterThan(SearchQueryRepository.getList().count, 0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
