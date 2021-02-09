//
//  FBStorage.swift
//  MyToDo
//
//  Created by Alexander on 2/9/21.
//

import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseStorage
import FirebaseStorageSwift

class FBStorage {
    var uid: String
    
    let storage: Storage
    
    init(uid: String, storage: Storage = Storage.storage() ) {
        self.uid = uid
        self.storage = storage
    }
    
    func uploadImage(img: UIImage) -> AnyPublisher<String, Error> {
        return Future<String, Error> { [weak self] promise in
            guard let self = self else {
                fatalError("upload image error")
            }
            if let imageData = img.jpegData(compressionQuality: CGFloat(0.1)) {
                self.storage.reference().child(self.uid).putData(imageData, metadata: nil) { data, error in
                    if let error = error {
                        return promise(.failure(error))
                    } else {
                        return promise(.success("success"))
                    }
                }
            } else {
                return promise(.failure("unwrap/case image to data" as! Error))
            }
        }.eraseToAnyPublisher()
    }
    
    func downloadImage() -> AnyPublisher<UIImage, Error> {
        return Future<UIImage, Error> { [weak self] promise in
            guard let self = self else {
                fatalError("download image err")
            }
            self.storage.reference().child(self.uid).getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    return promise(.failure(error))
                } else {
                    guard let data = data else {
                        return promise(.failure("wrong data format" as! Error))
                    }
                    guard let img = UIImage(data: data) else {
                        return promise(.failure("wrong data format" as! Error))
                    }
                    return promise(.success(img))
                }
            }
        }.eraseToAnyPublisher()
    }
}
