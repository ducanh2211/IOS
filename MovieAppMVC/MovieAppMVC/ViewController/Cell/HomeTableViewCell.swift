//
//  HomeTableViewCell.swift
//  MovieAppMVC
//
//  Created by Đức Anh Trần on 02/01/2023.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {

    public static var idetifier: String {
        get {
            return "HomeTableViewCell"
        }
    }
    
    public static var uiNibCell: UINib {
        get {
            return UINib(nibName: "HomeTableViewCell", bundle: nil)
        }
    }
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
        
    }
    
    // setup layout cho cell
    func configView() {
        backView.roundCorner(radius: 10)
        backView.configBorder(width: 1, color: .systemBackground)
        backView.backgroundColor = .systemGray5
        movieImageView.roundCorner(radius: 5)
        self.selectionStyle = .none
    }
    
    // nhận data (movie) được pass từ parent class "HomeViewController+TableView"
    // sau đó, populate các properties dựa trên data
    func populateTableView(movie: Movie) {
        let imageURLString = NetworkConstant.shared.imageServerAddress + (movie.backdropPath ?? "")
        let imageURL = URL(string: imageURLString)
       
        self.movieImageView.sd_setImage(with: imageURL) // hiển thị ảnh dựa trên URL (SDWebImage library)
        self.titleLabel.text = movie.title
        self.dateLabel.text = movie.releaseDate
        self.ratingLabel.text = "\(String(format: "%.1f", movie.voteAverage ?? ""))/10"
    }
}
