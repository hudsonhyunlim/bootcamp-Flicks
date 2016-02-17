//
//  Movie.swift
//  Flicks
//
//  Created by Hyun Lim on 2/16/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import Foundation

public class Movie {
    
    private static let PHOTO_URL = "https://image.tmdb.org/t/p/w"
/*  Sample JSON
    poster_path: "/inVq3FRqcYIRl2la8iZikYYxFNR.jpg",
    adult: false,
    overview: "Based upon Marvel Comics’ most unconventional anti-hero, DEADPOOL tells the origin story of former Special Forces operative turned mercenary Wade Wilson, who after being subjected to a rogue experiment that leaves him with accelerated healing powers, adopts the alter ego Deadpool. Armed with his new abilities and a dark, twisted sense of humor, Deadpool hunts down the man who nearly destroyed his life.",
    release_date: "2016-02-09",
    genre_ids: [
    35,
    12,
    28,
    878
    ],
    id: 293660,
    original_title: "Deadpool",
    original_language: "en",
    title: "Deadpool",
    backdrop_path: "/nbIrDhOtUpdD9HKDBRy02a8VhpV.jpg",
    popularity: 89.157605,
    vote_count: 698,
    video: false,
    vote_average: 7.2
*/
    var id: Int = -1
    var title: String = ""
    var posterPath: String = ""
    var backdropPath: String = ""
    var overview: String = ""
    var releaseDate: String = ""
    var language: String = ""
    var popularity: Float = 0.0
    var voteCount: Int = 0
    var voteAverage: Float = 0.0
    
    init(json: NSDictionary) {
        self.unpackJson(json)
    }
    
    private func unpackJson(json: NSDictionary) {
        if let id = json["id"] as? Int {
            self.id = id
        }
        
        if let title = json["title"] as? String {
            self.title = title
        }
        
        if let posterPath = json["poster_path"] as? String {
            self.posterPath = posterPath
        }
        
        if let backdropPath = json["backdrop_path"] as? String {
            self.backdropPath = backdropPath
        }
        
        if let overview = json["overview"] as? String {
            self.overview = overview
        }
        
        if let releaseDate = json["release_date"] as? String {
            self.releaseDate = releaseDate
        }
        
        if let language = json["language"] as? String {
            self.language = language
        }
        
        if let popularity = json["popularity"] as? Float {
            self.popularity = popularity
        }
        
        if let voteAverage = json["vote_average"] as? Float {
            self.voteAverage = voteAverage
        }
        
        if let voteCount = json["vote_count"] as? Int {
            self.voteCount = voteCount
        }
        
    }
    
    public func getPosterURL(width: Int) -> NSURL {
        let photoUrl = Movie.PHOTO_URL + String(width) + self.posterPath
        let url = NSURL(string: photoUrl)
        return url!
    }
    
}