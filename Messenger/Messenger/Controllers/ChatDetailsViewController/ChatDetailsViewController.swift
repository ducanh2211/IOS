//
//  ChatDetailsViewController.swift
//  Messenger
//
//  Created by Đức Anh Trần on 31/01/2023.
//

import UIKit
import PhotosUI
import MessageKit
import InputBarAccessoryView

class ChatDetailsViewController: MessagesViewController {
    
    // MARK: - Properties
    
    var messsageList: [Message] = []
    var otherUser: User?
    var chatId: String?
    var isNewChat: Bool
    var currentUser: Sender? {
        guard let userId = UserDefaultsValue.id,
              let name = UserDefaultsValue.name else {
            return Sender(senderId: "", displayName: "")
        }
        return Sender(senderId: userId, displayName: name)
    }
    
    /// - Parameters:
    ///   - otherUser:  The instance of struct `UserGeneral`.
    ///   - chatId: The id of chat which be `nil` if chat doesn't exist.
    ///   - isNewChat: The boolean  value to determine if the chat  existed or not. Default value is `false`
    init(otherUser: User?, chatId: String?, isNewChat: Bool = false) {
        self.otherUser = otherUser
        self.chatId = chatId
        self.isNewChat = isNewChat
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: ChatDetailsViewController: did load")
        
        configureView()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        createLeftInputStackView()
        if let chatId = chatId {
            listeningForChat(with: chatId)
        }
    }
    
    deinit {
        print("DEBUG: ChatDetailsViewController: deinit")
    }
    
    private func configureView() {
        let backButton = UIBarButtonItem()
        backButton.title = otherUser?.name ?? "User"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "video.fill"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "phone.fill"), style: .done, target: self, action: nil)
        ]
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    // MARK: - Helper
    
    private func listeningForChat(with chatId: String) {
        print("DEBUG: ChatDetailsViewController: listeningForChat() invoke")
        ChatManager.shared.fetchAllMessages(from: chatId) { [weak self] result in
            switch result {
            case .success(let messages):
                print("DEBUG: ChatDetailsViewController: fetchAllMessages() successfully")
                self?.messsageList = messages
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadData()
                    self?.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                }
            case .failure(let error):
                print("DEBUG: ChatDetailsViewController: fetchAllMessages() error: \(error.localizedDescription)")
            }
        }
    }
    
    private func createLeftInputStackView() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 36, height: 36), animated: true)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.onTouchUpInside { [weak self] _ in
            self?.presentMediaPicker()
        }
        
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 10)
        messageInputBar.inputTextView.layer.borderWidth = 1
        messageInputBar.inputTextView.layer.borderColor = UIColor.systemGray.cgColor
        messageInputBar.inputTextView.layer.cornerRadius = 12
        messageInputBar.inputTextView.layer.masksToBounds = true
        
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    private func presentMediaPicker() {
        let actionSheet = UIAlertController(title: "Attach Media",
                                            message: "What would you like to attach?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(actionSheet, animated: true)
    }
    
    private func presentPhotoPicker() {
        let actionSheet = UIAlertController(title: "Attach Photo",
                                            message: "Where would you like to attach photo from?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
        }))
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { _ in
            let photoLibrary = PHPhotoLibrary.shared()
            
            var configure = PHPickerConfiguration(photoLibrary: photoLibrary)
            configure.selection = .default
            configure.selectionLimit = 1
            
            let picker = PHPickerViewController(configuration: configure)
            picker.delegate = self
            self.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(actionSheet, animated: true)
    }
}

// MARK: - MessagesDataSource
extension ChatDetailsViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        guard let currentUser = currentUser else {
            fatalError("current user == nil")
        }
        return currentUser
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messsageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messsageList[indexPath.section]
    }
}

// MARK: - MessagesLayoutDelegate, MessagesDisplayDelegate
extension ChatDetailsViewController: MessagesLayoutDelegate, MessagesDisplayDelegate {
    func configureMediaMessageImageView(
        _ imageView: UIImageView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) {
        switch message.kind {
        case .photo(let media):
            imageView.contentMode = .scaleAspectFill
            DispatchQueue.main.async {
                imageView.sd_setImage(with: media.url)
            }
        default:
            break
        }
    }
    
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) {
        guard let otherUserProfileImageUrl = otherUser?.profileImageUrl,
              let currentUserProfileImageUrl = UserDefaultsValue.profileImageUrl,
              let currentUserId = UserDefaultsValue.id else {
            return
        }
        let currentUserUrl = URL(string: currentUserProfileImageUrl)
        let otherUserUrl = URL(string: otherUserProfileImageUrl)
        
        if message.sender.senderId == currentUserId {
            avatarView.sd_setImage(with: currentUserUrl)
        } else {
            avatarView.sd_setImage(with: otherUserUrl)
        }
    }
    
    func backgroundColor(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> UIColor {
        guard let currentUserId = UserDefaultsValue.id else {
            return UIColor()
        }
        return message.sender.senderId == currentUserId ? .systemBlue : .systemGray4
    }
}

// MARK: - MessageCellDelegate
extension ChatDetailsViewController: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
            let message = messageForItem(at: indexPath, in: messagesCollectionView) as! Message
            
            switch message.kind {
            case .photo(let media):
                let vc = PhotoPreviewViewController(imageUrl: media.url)
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true)
            default:
                break
            }
        }
    }
}

// MARK: - InputBarAccessoryViewDelegate
extension ChatDetailsViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        handleSendingMessage(inputBar, content: text, type: "text")
    }
    
    private func handleSendingMessage(_ inputBar: InputBarAccessoryView, content: String, type: String) {
        guard let otherUser = otherUser,
              let sender = currentUser else { return }
        
        let text = content.trimmingCharacters(in: .whitespaces)
        var message: Message!
        
        // Handle message types
        switch type {
        case "text":
            message = Message(sender: sender,
                              messageId: UUID().uuidString,
                              sentDate: Date(),
                              kind: .text(text))
        case "photo":
            guard let url = URL(string: text),
                  let placeholder = UIImage(systemName: "questionmark.circle") else { return }
            let media = Media(url: url,
                              image: nil,
                              placeholderImage: placeholder,
                              size: .zero)
            message = Message(sender: sender,
                              messageId: UUID().uuidString,
                              sentDate: Date(),
                              kind: .photo(media))
        default:
            break
        }
        
        // Create new chat or append message
        if isNewChat {
            // Create new Chat
            ChatManager.shared.createNewChat(withUser: otherUser, message: message) { [weak self] result in
                print("DEBUG: START create new chat ")
                switch result {
                case .success(let chatId):
                    print("DEBUG: create new chat success")
                    self?.chatId = chatId
                    self?.isNewChat = false
                    
                    // Call function to retrieve new message and update UI
                    self?.listeningForChat(with: chatId)
                case .failure(let error):
                    print("DEBUG: create new chat failed: \(error.localizedDescription)")
                }
                print("DEBUG: END create new chat")
            }
        }
        else {
            // Append message to existed Chat
            guard let chatId = chatId else { return }
            ChatManager.shared.sendMessage(to: chatId, message: message, otherUser: otherUser) { sucess in
                print("DEBUG: APPEND message")
                if sucess {
                    print("DEBUG: append message to chat success")
                } else {
                    print("DEBUG: append message to chat failed")
                }
            }
        }
        
        inputBar.inputTextView.text = nil
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ChatDetailsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        let imageItem = results
            .map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) }
            .first
        
        // Grab UIImage
        imageItem?.loadObject(ofClass: UIImage.self) { image, error in
            guard let image = image as? UIImage,
                  let imageData = image.pngData(),
                  let chatId = self.chatId else { return }
            
            // Upload image to Storage and download it's URL as string
            let path = "chat_images/\(chatId)"
            StorageManager.shared.uploadImage(forPath: path, with: imageData) { [weak self] result in
                switch result {
                case .success(let urlString):
                    // Sending photo mesage
                    self?.handleSendingMessage(self!.messageInputBar,
                                               content: urlString,
                                               type: "photo")
                case .failure(let error):
                    print("DEBUG: ChatDetailsViewController uploadImage() error: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension ChatDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        
    }
}
