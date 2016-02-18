//
//  MovieGridCell.swift
//  Flicks
//
//  Created by Hyun Lim on 2/17/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

class MovieGridCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    internal weak var movie:Movie? {
        didSet {
            if let movie = self.movie {
                FlicksData.loadImageIntoView(movie.getPosterURL(Movie.PHOTO_SIZES.SMALL.rawValue), imageView: self.posterImageView)
            }
        }
    }
    
}
