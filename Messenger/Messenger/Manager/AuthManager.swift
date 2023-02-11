//
//  AuthManager.swift
//  Messenger
//
//  Created by Đức Anh Trần on 01/02/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
//import FirebaseStorage
import FirebaseCore

enum AuthManagerError: String {
    case emailAlreadyInUse = "Email already is used by another user"
    case invalidEmail = "Invalid email"
    case wrongPassword = "Email or password is wrong"
    case userNotFound = "Please create an account before log in"
}

final class AuthManager {
    
    /// Return the shared default object.
    static let shared = AuthManager()

    private init() {}
    
    private let db = Firestore.firestore()
    
}

extension AuthManager {
    
    /// Create user with email, password in database.
    ///
    ///  - Parameters:
    ///    - authCredential: An instance of struct `AuthCredential`.
    ///    - completion: The block that take `Error` and execute after create user.
    public func registerUser(
        withAuthCredential authCredential: AuthCredential,
        completion: @escaping (Error?) -> Void
    ) {
        let email = authCredential.email
        let password = authCredential.password
        let firstName = authCredential.firstName
        let lastName = authCredential.lastName
        let profileImageData = authCredential.profileImageData
                
        // Create user with FirebaseAuth API.
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let auth = authResult, error == nil else {
                print("DEBUG: CREATE USER FAILED IN AUTH MANAGER")
                completion(error)
                return
            }
            let userId = auth.user.uid
            let path = "profile_images/\(userId)"
            
            // Upload profile image
            StorageManager.shared.uploadImage(forPath: path, with: profileImageData) { result in
                switch result {
                case .success(let imageUrlString):
                    // Save current user's info to UserDefaults.
                    UserDefaults.standard.set(userId, forKey: "uid")
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                    UserDefaults.standard.set(imageUrlString, forKey: "profile_image_url")
                    
                    let userDocumentData = User(userId: userId,
                                                name: "\(firstName) \(lastName)",
                                                email: email,
                                                password: password,
                                                profileImageUrl: imageUrlString)
                    
                    // Add user document to root collection `users`.
                    self?.db.collection("users").document(userId).setData(userDocumentData.dictionary) { error in
                        guard error == nil else {
                            print("DEBUG: Failed to add document to users-detail")
                            completion(error)
                            return
                        }
                        completion(nil)
                    }
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
    
    /// Fetch all users at "users" root collection from FireStore.
    public func fetchAllUsers(
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        db.collection("users").order(by: "full_name")
            .getDocuments { querySnapshot, error in
                guard let queryDocuments = querySnapshot?.documents, error == nil else {
                    completion(.failure(error!))
                    return
                }
                let documents = queryDocuments.map { $0.data() }
                
                let usersData: [User] = documents.compactMap {
                    guard let user = User(dictionary: $0) else {
                        return nil
                    }
                    return user
                }
                
                completion(.success(usersData))
            }
    }
    
    /// Fetch user with a given uid.
    ///
    /// - Parameters:
    ///   - userId: The id of user to be fetch.
    ///   - completion: The block to execute after get data from FireStore.
    public func fetchUser(
        withUserId userId: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        db.collection("users").document(userId).getDocument { documentSnapshot, error in
            guard let document = documentSnapshot?.data() else {
                completion(.failure(error!))
                return
            }

            guard let userData = User(dictionary: document) else {
                return
            }
            completion(.success(userData))
        }
    }
    
}
