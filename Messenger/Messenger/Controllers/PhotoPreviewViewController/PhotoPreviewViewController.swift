//
//  PhotoPreviewViewController.swift
//  Messenger
//
//  Created by Đức Anh Trần on 08/02/2023.
//

import UIKit

class PhotoPreviewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    private var imageUrl: URL?
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        print("DEBUG: PhotoPreviewViewController did load")
    }
    
    deinit {
        print("DEBUG: PhotoPreviewViewController deinit")
    }
    
    private func initialSetup() {
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: imageUrl)
        imageView.layer.backgroundColor = UIColor.systemBackground.cgColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapCloseButton))
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
}
