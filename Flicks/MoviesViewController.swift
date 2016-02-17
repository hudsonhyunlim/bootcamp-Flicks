//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Hyun Lim on 2/16/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit
import MBProgressHUD

class MoviesViewController: UIViewController {

    @IBOutlet weak var moviesTableView: UITableView!
    
    var flicksData:FlicksData?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self
        
        self.flicksData = FlicksData()
        self.flicksData!.delegate = self
        
        self.refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.moviesTableView.insertSubview(self.refreshControl, atIndex: 0)
        
        self.flicksData!.refetchPosts({ () -> Void in
                self.moviesTableView.reloadData()
            }, error: { (_: (NSError?)) in
            })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "com.lyft.segueToDetails" {
            let cell = sender as! UITableViewCell
            let indexPath = self.moviesTableView.indexPathForCell(cell)
            let vc = segue.destinationViewController as! DetailViewController
            vc.movie = self.flicksData!.movies[indexPath!.row]
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("com.lyft.MovieCell", forIndexPath: indexPath) as! MovieCell
        if let flicksData = self.flicksData as FlicksData? {
            cell.movie = flicksData.movies[indexPath.row]
        }
        return cell
    }
}

extension MoviesViewController: UITableViewDelegate {
    
}

extension MoviesViewController: FlicksDataDelegateProtocol {
    
    func dataInFlight() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func dataFinishedFlight() {
        self.refreshControl.endRefreshing()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func dataErrored() {
        // TODO: show error
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
}