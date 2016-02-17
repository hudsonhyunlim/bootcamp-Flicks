//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Hyun Lim on 2/16/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var moviesTableView: UITableView!
    
    var flicksData:FlicksData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self
        
        self.flicksData = FlicksData()
        self.flicksData!.refetchPosts({ () -> Void in
            self.moviesTableView.reloadData()
            
            }, error: { (_: (NSError?)) in
                
            })
        
    }
}

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let flicksData = self.flicksData as FlicksData? {
            return flicksData.movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.lyft.MovieCell", forIndexPath: indexPath)
        if let flicksData = self.flicksData as FlicksData? {
            cell.textLabel!.text = flicksData.movies[indexPath.row].title
        }
        return cell
    }
}

extension MoviesViewController: UITableViewDelegate {
    
}