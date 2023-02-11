//
//  MovieCollectionViewCell.swift
//  CloneNetflix
//
//  Created by Đức Anh Trần on 04/01/2023.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {

    static let identifier = "MovieCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "MovieCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .blue
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.image = UIImage(named: "netflixLogo")
    }

    func configure(movie: Movie) {
        guard let url = URL(string: NetworkConstant.imageAddress + (movie.posterPath ?? "")) else { return }
        self.movieImageView.sd_setImage(with: url)
    }
}
