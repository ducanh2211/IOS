//
//  ChatsTableViewCell.swift
//  Messenger
//
//  Created by Đức Anh Trần on 03/02/2023.
//

import UIKit
import SDWebImage

class ChatsTableViewCell: UITableViewCell {
    
    static let identifier = "ChatsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ChatsTableViewCell", bundle: nil)
    }

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMessageLabel: UILabel!
    @IBOutlet weak var isReadIndicator: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
        
    }
    
    private func configureView() {
        // avatar image view
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        
        // user name label
        userNameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        // user message label
        userMessageLabel.font = .systemFont(ofSize: 15, weight: .regular)
        userMessageLabel.numberOfLines = 1
        
        // is read indicator button
        isReadIndicator.imageView?.image = UIImage(systemName: "circle.fill")
        isReadIndicator.layer.cornerRadius = isReadIndicator.bounds.height / 2
        isReadIndicator.layer.masksToBounds = true
    }
    
    func configure(with model: ChatDatabase) {
        guard let currentUserId = UserDefaultsValue.id else { return }
        
        // user name label
        let name = model.otherUser.name
        userNameLabel.text = name
        
        // user message label
        var message = ""
        if currentUserId == model.latestMessage.senderId {
            message = model.latestMessage.kind == "photo" ? "You sent a photo." : "You: \(model.latestMessage.content)"
        }
        else {
            message = model.latestMessage.kind == "photo" ? "\(name) sent you a photo." : model.latestMessage.content
        }
        userMessageLabel.text = message
        
        // avatar image view
        guard let url = URL(string: model.otherUser.profileImageUrl) else {
            avatarImageView.image = UIImage(systemName: "questionmark")
            return
        }
        self.avatarImageView.sd_setImage(with: url)
        
        // is read indicator
        if model.latestMessage.isRead {
            isReadIndicator.isHidden = true
        } else {
            isReadIndicator.isHidden = false
        }
    }
}
