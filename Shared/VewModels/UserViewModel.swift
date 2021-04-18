//
//  UserViewModel.swift
//  MyToDo
//
//  Created by Alexander on 2/5/21.
//

import Foundation
import Combine
import SwiftUI

class UserViewModel: ObservableObject {
    var logout: () -> Void
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var image: UIImage?
    @Published var storage: FBStorage

    private var cancellables = Set<AnyCancellable>()

    init(logout: @escaping () -> Void, image: UIImage = UIImage(), storage: FBStorage) {
        self.logout = logout
        self.image = image
        self.storage = storage
    }

    func updateImage() {
        self.storage.downloadImage()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { output in
                    if let image = UIImage(data: output) {
                        self.image = image
                    }
                })
            .store(in: &cancellables)
    }

    func uploadImage(_ newImage: UIImage, imageQuality: ImageCompression = ImageCompression.without) {
        guard let newDataImage = newImage.jpegData(compressionQuality: imageQuality.rawValue) else {
            return
        }
        storage.uploadImage(imageData: newDataImage)
            .sink(receiveCompletion: { completion in
                if case .finished  = completion {
                    self.updateImage()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}

extension UserViewModel {
    enum ImageCompression: CGFloat {
        case without = 1
        case medium  = 0.5
        case strong = 0.1
    }
}
