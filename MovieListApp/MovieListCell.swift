//
//  MovieListCell.swift
//  MovieListApp
//
//  Created by Hassan Ahmed on 15/08/2017.
//  Copyright © 2017 Hassan Ahmed. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieListCell: UITableViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!

    var model: Movie? {
        willSet {
            if newValue != nil {
                self.movieTitleLabel.text = newValue!.title
                self.movieReleaseLabel.text = newValue!.formatedReleaseDate
                self.movieOverviewLabel.text = newValue!.overview
                if let url = URL(string: "\(Environment.imageBase)\(newValue!.posterPath)") {
                    self.movieImage.af_setImage(withURL: url)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        self.movieTitleLabel.text = nil
        self.movieReleaseLabel.text = nil
        self.movieOverviewLabel.text = nil
        self.movieImage.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
