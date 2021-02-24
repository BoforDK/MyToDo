//
//  ImageCellViewModel.swift
//  MyToDo
//
//  Created by Alexander on 2/9/21.
//

import Foundation
import Combine
import SwiftUI

class ImageCellViewModel: ObservableObject {
    @Published var image: UIImage
    @Published var storage: FBStorage

    private var cancellables = Set<AnyCancellable>()

    init(image: UIImage = UIImage(), storage: FBStorage) {
        self.image = image
        self.storage = storage

    }

    func updateImage() {
        self.storage.downloadImage()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("ImageCellViewModel: \(error)")
                default:
                    return
                }
            }, receiveValue: { output in
                if let image = UIImage(data: output) {
                    self.image = image
                } else {
                    print("invalid image format")
                }
            })
            .store(in: &cancellables)
    }

    func uploadImage(_ newImage: UIImage) {
        if let newDataImage = newImage.jpegData(compressionQuality: 0.1) {
            storage.uploadImage(imageData: newDataImage)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("ImageCellViewModel: \(error)")
                    default:
                        self.updateImage()
                        return
                    }
                }, receiveValue: { _ in })
                .store(in: &cancellables)
        } else {
            print("Error image format")
        }
    }
}
