//
//  Movie.swift
//  MovieListApp
//
//  Created by Hassan Ahmed on 15/08/2017.
//  Copyright © 2017 Hassan Ahmed. All rights reserved.
//

import Foundation

class Movie {
    var voteCount = 0
    var movieId = -1
    var video = false
    var voteAverage = 0.0
    
    var title = ""
    var popularity = 0.0
    var posterPath = ""
    var originalLanguage = "en"
    var originalTitle = ""

    var genreIds = [Int]()
    var backdropPath = ""
    var adult = false
    var overview = ""
    var releaseDate = Date.init(timeIntervalSince1970: 0.0)
    
    var formatedReleaseDate: String {
        get {
            let df = DateFormatter()
            df.dateFormat = "MMM d, yyyy"
            return df.string(from: releaseDate)
        }
    }
    
    convenience init(dictionary: [String : Any]) {
        self.init()
        
        if let voteCount = dictionary["vote_count"] as? Int {
            self.voteCount = voteCount
        }
        
        if let movieId = dictionary["id"] as? Int {
            self.movieId = movieId
        }
        
        if let video = dictionary["video"] as? Bool {
            self.video = video
        }
        
        if let voteAverage = dictionary["vote_average"] as? Double {
            self.voteAverage = voteAverage
        }
        
        if let title = dictionary["title"] as? String {
            self.title = title
        }
        
        if let popularity = dictionary["popularity"] as? Double {
            self.popularity = popularity
        }
        
        if let posterPath = dictionary["poster_path"] as? String {
            self.posterPath = posterPath
        }
        
        if let originalLanguage = dictionary["original_language"] as? String {
            self.originalLanguage = originalLanguage
        }
        
        if let originalTitle = dictionary["original_title"] as? String {
            self.originalTitle  = originalTitle
        }
        
        if let genreIds = dictionary["genre_ids"] as? [Int] {
            self.genreIds.append(contentsOf: genreIds)
        }
        
        if let backdropPath = dictionary["backdrop_path"] as? String {
            self.backdropPath = backdropPath
        }
        
        if let adult = dictionary["adult"] as? Bool {
            self.adult = adult
        }
        
        if let overview = dictionary["overview"] as? String {
            self.overview = overview
        }
        
        if let releaseDate = dictionary["release_date"] as? String {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            
            if let date = df.date(from: releaseDate) {
                self.releaseDate = date
            }
        }
    }
}
