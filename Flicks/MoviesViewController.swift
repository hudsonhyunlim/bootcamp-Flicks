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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self
    }
}

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.lyft.MovieCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = "row \(indexPath.row)"
        return cell
    }
}

extension MoviesViewController: UITableViewDelegate {
    
}