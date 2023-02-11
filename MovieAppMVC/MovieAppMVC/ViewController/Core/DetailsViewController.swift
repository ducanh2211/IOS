//
//  DetailsViewController.swift
//  MovieAppMVC
//
//  Created by Đức Anh Trần on 02/01/2023.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController {

    public static let storyBoardId = "DetailsViewController"
    
    // movie dùng để hứng data được truyền từ "HomeViewController"
    var movie: Movie?
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }
    
    // populate propeties dựa trên data (movie)
    func configView() {
        self.title = "Details Movie"
        
        guard let movie = movie else { return }
        let imageURLString = NetworkConstant.shared.imageServerAddress + (movie.backdropPath ?? "")
        let imageURL = URL(string: imageURLString)
        
        self.movieImageView.sd_setImage(with: imageURL) // hiển thị ảnh dựa trên URL (SDWebImage library)
        self.titleLabel.text = movie.title
        self.descriptionLabel.text = movie.overview
    }

}
