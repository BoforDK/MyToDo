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

    func uploadImage(imageData: Data) -> AnyPublisher<StorageMetadata, StorageError> {
        return Future<StorageMetadata, StorageError> { [weak self] promise in
            guard let strongSelf = self else {
                return
            }
            strongSelf.storage.reference().child(strongSelf.uid).putData(imageData, metadata: nil) { metadata, error in
                if let message = error?.localizedDescription {
                    return promise(.failure(.errorConnection(message)))
                } else {
                    guard let metadata = metadata else {
                        return promise(.failure(StorageError.invalidDownloadFormat))
                    }
                    return promise(.success(metadata))
                }
            }
        }.eraseToAnyPublisher()
    }

    func downloadImage(quality: ImageSize = ImageSize.medium) -> AnyPublisher<Data, StorageError> {
        return Future<Data, StorageError> { [weak self] promise in
            guard let strongSelf = self else {
                return
            }
            strongSelf.storage.reference().child(strongSelf.uid).getData(maxSize: quality.rawValue) { data, error in
                if let message = error?.localizedDescription {
                    return promise(.failure(.errorConnection(message)))
                } else {
                    guard let data = data else {
                        return promise(.failure(.invalidDownloadFormat))
                    }
                    return promise(.success(data))
                }
            }
        }.eraseToAnyPublisher()
    }

    enum ImageSize: Int64 {
        case large = 10485760
        case medium  = 5242880
        case icon = 1048576
    }

    enum StorageError: Error {
        case invalidDownloadFormat
        case errorConnection(String)
    }
}
