//
//  StorageManager.swift
//  CoupleAnimal
//
//  Created by Nikita on 12.02.23.
//

import Foundation
import UIKit
import FirebaseStorage

class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    public typealias PictureComplition = ((Result<String, Error>) -> Void)
    //MARK: Interaction with picture
    
    public func uploadProfilePicture(data: Data, fileName: String, complition: @escaping PictureComplition) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { metadata, error in
            guard error == nil else {
                complition(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    complition(.failure(StorageErrors.failedToGetURL))
                    return
                }
                let urlString = url.absoluteString
                print("downland url returned: \(urlString)")
                complition(.success(urlString))
            }
        }
    }
    
    public func downloadURL(path: String, complition:@escaping ((Result<URL, Error>) -> Void)) {
        let reference = storage.child(path)
        
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                complition(.failure(StorageErrors.failedToGetURL))
                return
            }
            complition(.success(url))
        }
    }
    //MARK: Enum errors
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetURL
    }
}
