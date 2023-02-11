//
//  StorageManager.swift
//  Messenger
//
//  Created by Đức Anh Trần on 01/02/2023.
//

import Foundation
import FirebaseStorage

class StorageManager {
    static let shared = StorageManager()
    
    private let storageRef = Storage.storage().reference()
    
    /// Upload image from data to FireStorage and download back the image URL.
    ///
    /// - Parameters:
    ///   - path: The path of the image which is stored in FireStorage.
    ///   - imageData: The image as type data.
    ///   - completion: The block to execute after upload the image. It either return image URL string or error.
    public func uploadImage(
        forPath path: String,
        with imageData: Data,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let fileName = UUID().uuidString
        storageRef.child("\(path)/\(fileName).png").putData(imageData) { [weak self] _, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            self?.storageRef.child("\(path)/\(fileName).png").downloadURL { url, error in
                guard let urlString = url?.absoluteString, error == nil else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(urlString))
            }
        }
    }
    
}
