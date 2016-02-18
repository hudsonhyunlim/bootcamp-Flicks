//
//  MovieCell.swift
//  Flicks
//
//  Created by Hyun Lim on 2/16/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    internal weak var movie:Movie? {
        didSet {
            if let movie = self.movie {
                self.titleLabel.text = movie.title
                self.overviewLabel.text = movie.overview
                FlicksData.loadImageIntoView(movie.getPosterURL(Movie.PHOTO_SIZES.SMALL.rawValue), imageView: self.posterImageView)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
