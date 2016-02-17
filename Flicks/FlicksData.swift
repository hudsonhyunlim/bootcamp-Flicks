//
//  FlicksData.swift
//  Flicks
//
//  Created by Hyun Lim on 2/16/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import Foundation
import AFNetworking

public final class FlicksData {
    // ...
    
    static let CLIENT_ID = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    static let POPULAR_ENDPOINT = "https://api.themoviedb.org/3/movie/now_playing"
    
    public var movies:[Movie] = []
    
    init() {
        self.movies = []
    }
    
    public func refetchPosts(success: () -> Void, error:((NSError?) -> Void)?) {
        FlicksData.fetchPosts({(movies:[Movie]) in
            self.movies = movies
            success()
        }, errorCallback: {(NSError) in
            // TODO: how to do error handling?
        });
    }
    
    private static func fetchPosts(successCallback: (movies:[Movie]) -> Void, errorCallback: ((NSError?) -> Void)?) {
        let params = ["api_key": FlicksData.CLIENT_ID]
        let manager = AFHTTPRequestOperationManager()
        manager.GET(FlicksData.POPULAR_ENDPOINT, parameters: params, success: { (operation ,responseObject) -> Void in
            if let results = responseObject["results"] as? NSArray {
                var movies:[Movie] = []
                for result in results as! [NSDictionary] {
                    movies.append(Movie(json: result))
                }
                successCallback(movies: movies)
            }
            }, failure: { (operation, requestError) -> Void in
                print("whoa error")
                if let errorCallback = errorCallback {
                    errorCallback(requestError)
                }
        })
    }

}