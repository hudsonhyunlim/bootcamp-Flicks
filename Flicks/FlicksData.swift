//
//  FlicksData.swift
//  Flicks
//
//  Created by Hyun Lim on 2/16/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import Foundation
import AFNetworking

protocol FlicksDataDelegateProtocol: class {
    func dataInFlight() -> Void
    func dataFinishedFlight() -> Void
    func dataErrored() -> Void
}

public final class FlicksData {
    // ...
    
    static let CLIENT_ID = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    static let POPULAR_ENDPOINT = "https://api.themoviedb.org/3/movie/now_playing"
    
    public var movies:[Movie] = []
    public var dataInFlight:Bool = false
    weak var delegate:FlicksDataDelegateProtocol?
    
    init() {
        self.movies = []
    }
    
    public func refetchPosts(success: () -> Void, error:((NSError?) -> Void)?) {
        if !self.dataInFlight {
            self.dataInFlight = true
            if let delegate = self.delegate {
                delegate.dataInFlight()
            }
            FlicksData.fetchPosts({(movies:[Movie]) in
                self.movies = movies
                success()
                self.dataInFlight = false
                if let delegate = self.delegate {
                    delegate.dataFinishedFlight()
                }
            }, errorCallback: {(NSError) in
                // TODO: how to do error handling?
                self.dataInFlight = false
                if let delegate = self.delegate {
                    delegate.dataErrored()
                }
            });
        }
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
                if let errorCallback = errorCallback {
                    errorCallback(requestError)
                }
        })
    }

}