//
//  NewChatTableViewCell.swift
//  Messenger
//
//  Created by Đức Anh Trần on 08/02/2023.
//

import UIKit
import SDWebImage

class NewChatTableViewCell: UITableViewCell {

    static let identifier = "NewChatTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "NewChatTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    private func configureView() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        
        userNameLabel.numberOfLines = 0
        userNameLabel.font = .systemFont(ofSize: 18, weight: .regular)
    }
    
    func configure(with model: User) {
        userNameLabel.text = model.name
        
        guard let url = URL(string: model.profileImageUrl) else {
            avatarImageView.image = UIImage(systemName: "questionmark")
            return
        }
        avatarImageView.sd_setImage(with: url)
    }
}
