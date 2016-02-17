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
                self.posterImageView.setImageWithURL(movie.getPosterURL(Movie.PHOTO_SIZES.SMALL.rawValue))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
