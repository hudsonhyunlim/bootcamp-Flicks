//
//  DetailViewController.swift
//  Flicks
//
//  Created by Hyun Lim on 2/16/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie:Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let movie = self.movie {
            self.titleLabel.text = movie.title
            self.overviewLabel.text = movie.overview
            
            FlicksData.loadImageIntoView(movie.getPosterURL(
                Movie.PHOTO_SIZES.MICRO.rawValue),
                imageView: self.posterImageView,
                success: {() -> Void in
                    self.posterImageView.setImageWithURL(movie.getPosterURL(Movie.PHOTO_SIZES.LARGE.rawValue))
                },
                failure: {() -> Void in
                    // fallback and try once more
                    self.posterImageView.setImageWithURL(movie.getPosterURL(Movie.PHOTO_SIZES.SMALL.rawValue))
                })
        }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.infoView.frame.size.height + self.infoView.frame.origin.y)
        
        self.overviewLabel.sizeToFit()
    }

}
