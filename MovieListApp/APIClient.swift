//
//  APIClient.swift
//  MovieListApp
//
//  Created by Hassan Ahmed on 15/08/2017.
//  Copyright © 2017 Hassan Ahmed. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    static func getSearchResults(withSearchText text:String, forPage page:Int, andBlock block:@escaping ((_ error: Error?,_ response: MovieSearchResponse)->Void)) {
        let endpoint = "search/movie"
        let url = "\(Environment.baseURL)\(endpoint)"
        
        let parameters: Parameters = [
            "api_key": Environment.apiKey,
            "query": text,
            "page": page
        ]
        
        Alamofire.request(url, parameters: parameters).responseJSON { (response) in
            var error: Error?
            var searchResponse = MovieSearchResponse()
            
            
            if response.result.isSuccess {
                if let code = response.response?.statusCode {
                    if code == 200 {
                        if let value = response.result.value as? [String : Any] {
                            if let errors = value["errors"] as? [String] {
                                if let message = errors.first {
                                    error = NSError(domain: ErrorDomain.Search.getSearchResultError, code: code, userInfo:["message": message])
                                }
                            }
                            else {
                                searchResponse = MovieSearchResponse(dictionary: value)
                            }
                        }
                    }
                    else {
                        error = NSError(domain: ErrorDomain.Search.getSearchResultError, code: code, userInfo:[:])
                    }
                }
            }
            else {
                error = response.result.error
            }
            
            block(error, searchResponse)
        }
    }
}
