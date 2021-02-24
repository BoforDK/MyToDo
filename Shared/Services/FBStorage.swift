//
//  FBStorage.swift
//  MyToDo
//
//  Created by Alexander on 2/9/21.
//

import Foundation
import Combine
import Firebase
import FirebaseStorage
import FirebaseStorageSwift

class FBStorage {
    private var uid: String

    private let storage: Storage

    init(uid: String, storage: Storage = Storage.storage() ) {
        self.uid = uid
        self.storage = storage
    }

    func uploadImage(imageData: Data) -> AnyPublisher<StorageMetadata, Error> {
        return Future<StorageMetadata, Error> { [weak self] promise in
            guard let strongSelf = self else {
                return
            }
            strongSelf.storage.reference().child(strongSelf.uid).putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    return promise(.failure(StorageError.errorConnect(error)))
                } else {
                    guard let metadata = metadata else {
                        return promise(.failure(StorageError.invalidDownloadFormat))
                    }
                    return promise(.success(metadata))
                }
            }
        }.eraseToAnyPublisher()
    }

    func downloadImage(quality: ImageQuality = ImageQuality.theNormalest) -> AnyPublisher<Data, Error> {
        return Future<Data, Error> { [weak self] promise in
            guard let self = self else {
                fatalError("download image err")
            }
            self.storage.reference().child(self.uid).getData(maxSize: quality.rawValue) { data, error in
                if let error = error {
                    return promise(.failure(StorageError.errorConnect(error)))
                } else {
                    guard let data = data else {
                        return promise(.failure(StorageError.invalidDownloadFormat))
                    }
                    return promise(.success(data))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    enum ImageQuality: Int64 {
        case theBest = 10485760
        case theNormalest  = 5242880
        case theWorst = 1048576
    }

    enum StorageError: Error {
        case invalidDownloadFormat
        case errorConnect(Error)
    }
}
