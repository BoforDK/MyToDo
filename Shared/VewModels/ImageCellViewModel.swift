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
                self.image = output
            })
            .store(in: &cancellables)
    }
    
    func uploadImage(_ newImage: UIImage) {
        storage.uploadImage(img: newImage)
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
    }
    
}
