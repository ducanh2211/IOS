# Database schema

"users": [
    "userId_1": [
        "user_id": String,
        "email_address": String,
        "full_name": String,
        "password": String,
        "profile_image_url": String,
        "chats": [
            "chatId_1": [
                "chat_id": String,
                "latest_message": {
                    "sender_id": String,
                    "content": String,
                    "kind": String,
                    "is_read": Bool,
                    "sent_date": Timestamp
                },
                "other_user": {
                    "user_id": String,
                    "full_name": String,
                    "profile_image_url": String 
                }
            ]
            "chatId_2": ...,
            "chatId_3": ...,
        ]
    ]
    "userId_2": ...,
    "userId_3": ...,
]
=> Root element: users(collection) -> userId(document) -> chats(sub-collection) -> chatId(document)

"chats": [
    "chatId": [
        "messages": [
            "messageId": [
                "message_id": String,
                "content": String,
                "kind": String,
                "sent_date": Timestamp,
                "sender": {
                    "user_id": String,
                    "full_name": String,
                    "profile_image_url": String  
                },
                "receiver": {
                    "user_id": String,
                    "full_name": String,
                    "profile_image_url": String 
                }
            ]
        ]
    ]
]
=> Root element: chats(collection) -> chatId(document) -> messages(sub-collection) -> messageId(document)


# Controllers của app
1. LoginViewController: cho phép người dùng đăng nhập với email và password.
2. RegisterViewController: cho phép người dùng đăng ký account.
3. MainTabbarViewController: chứa 2 view controller chính của app (ChatsViewController và SettingsViewController).
4. ChatsViewController: hiển thị tất cả các đoạn hội thoại của user, khi user tap vào cell sẽ push sang 
ChatDetailsViewController.
5. ChatDetailsViewController: hiển thị toàn bộ tin nhắn giữa 2 user.   
6. SetttingsViewController: hiển thị thông tin cá nhân của user hiện tại và cho phép chỉnh sửa một số cài đặt.
7. NewChatViewController: fetch tất cả các users từ database và hiển thị lên tableView, khi nhấn vào cell sẽ cho phép 
user hiện tại tạo cuộc hội thoại với user đã chọn.  
8. PhotoPreviewViewController: khi user tap vào ảnh trong cuộc hội thoại sẽ đưa đến màn này để hiển thị ảnh.

# Managers của app
1. AuthManager: xử lý logic liên quan đến việc đăng nhập, đăng ký user, fetch user từ database.
2. ChatManager: xử lý logic liên quan đến cuộc hội thoại như: tạo hội thoại mới, gửi tin nhắn, xoá hội thoại, fetch hội thoại và tin 
nhắn từ database.
3. StorageManager: xử lý logic liên quan đến upload và download ảnh, video từ database.
