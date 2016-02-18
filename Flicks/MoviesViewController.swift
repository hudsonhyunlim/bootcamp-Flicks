//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Hyun Lim on 2/16/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit
import MBProgressHUD
import SVPullToRefresh

class MoviesViewController: UIViewController {

    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var errorNotificationView: UIView!
    @IBOutlet weak var layoutSelector: UISegmentedControl!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var flicksData:FlicksData?
    var endpoint:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide subviews
        self.errorNotificationView.hidden = true
        self.moviesCollectionView.hidden = true
        
        // add delegates
        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self
        self.moviesCollectionView.delegate = self
        self.moviesCollectionView.dataSource = self
        
        // initialize app
        self.flicksData = FlicksData()
        self.flicksData!.delegate = self
        
        // add pull to refresh (SVPullToRefresh)
        self.moviesTableView.addPullToRefreshWithActionHandler(self.onPullToRefresh)
        self.moviesCollectionView.addPullToRefreshWithActionHandler(self.onPullToRefresh)
        
        // add infinite scroll (SVPullToRefresh)
        self.moviesTableView.addInfiniteScrollingWithActionHandler(self.onInfiniteScroll)
        self.moviesCollectionView.addInfiniteScrollingWithActionHandler(self.onInfiniteScroll)
        
        // initial load
        self.flicksData!.refetchPosts(
            self.endpoint!,
            success: { () -> Void in
                self.reloadView()
            },
            error: { (_: (NSError?)) in
                // TODO: what should I do
            })
        
        
        // Initialize the UISearchBar
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Filter Title"
        self.navigationItem.titleView = searchBar
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var index:Int?
        if segue.identifier == "com.lyft.segueToDetails" {
            let cell = sender as! UITableViewCell
            let indexPath = self.moviesTableView.indexPathForCell(cell)
            index = indexPath!.row
        } else if segue.identifier == "com.lyft.segueFromGridToDetails" {
            let cell = sender as! UICollectionViewCell
            let indexPath = self.moviesCollectionView.indexPathForCell(cell)
            index = indexPath!.row
        }
        let vc = segue.destinationViewController as! DetailViewController
        if let index = index {
            vc.movie = self.flicksData!.movies[index]
        }
    }
    
    @IBAction func onLayoutSelectorChanged(sender: UISegmentedControl) {
        let selected = sender.selectedSegmentIndex
        if selected == 0 {
            self.moviesTableView.hidden = false
            self.moviesCollectionView.hidden = true
        } else {
            self.moviesTableView.hidden = true
            self.moviesCollectionView.hidden = false
        }
        self.reloadView()
    }
    
    private func getMoviesCount() -> Int {
        if let flicksData = self.flicksData as FlicksData? {
            return flicksData.movies.count
        } else {
            return 0
        }
    }
    
    private func reloadView() {
        if !self.moviesTableView.hidden {
            self.moviesTableView.reloadData()
            self.moviesTableView.infiniteScrollingView.stopAnimating()
            self.moviesTableView.pullToRefreshView.stopAnimating()
        } else {
            self.moviesCollectionView.reloadData()
            self.moviesCollectionView.infiniteScrollingView.stopAnimating()
            self.moviesCollectionView.pullToRefreshView.stopAnimating()
        }
        
    }
    
    private func onInfiniteScroll() {
        self.flicksData!.addMorePosts(
            self.endpoint!,
            success: { () -> Void in
                // call [tableView.infiniteScrollingView stopAnimating] when done
                self.reloadView()
            }
        )
    }
    
    private func onPullToRefresh() {
        self.flicksData!.refetchPosts(
            self.endpoint!,
            success: { () -> Void in
                self.reloadView()
            },
            error: { (_: (NSError?)) in
        })
    }
}

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getMoviesCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.lyft.MovieCell", forIndexPath: indexPath) as! MovieCell
        if let flicksData = self.flicksData as FlicksData? {
            cell.movie = flicksData.movies[indexPath.row]
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

extension MoviesViewController: UITableViewDelegate {
    
}

extension MoviesViewController: FlicksDataDelegateProtocol {
    
    func dataInFlight() {
        self.errorNotificationView.hidden = true
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func dataFinishedFlight() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func dataErrored() {
        self.errorNotificationView.hidden = false
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
}

extension MoviesViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getMoviesCount()
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("com.lyft.movieGridCell", forIndexPath: indexPath) as! MovieGridCell
        
        if let flicksData = self.flicksData as FlicksData? {
            cell.movie = flicksData.movies[indexPath.row]
        }
        
        return cell
    }
    
}

extension MoviesViewController: UICollectionViewDelegate {
    
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.flicksData?.setMovies(nil)
        } else {
            self.flicksData?.setMovies(searchText)
        }
        self.reloadView()
    }
}