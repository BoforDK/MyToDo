//
//  CaptureImageView.swift
//  MyToDo
//
//  Created by Alexander on 2/9/21.
//

import SwiftUI


struct CaptureImageView {
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    var sourceType: UIImagePickerController.SourceType
    var uploadImage: (UIImage) -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image, uploadImage: uploadImage)
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        if sourceType == .camera {
            picker.cameraDevice = .front
        }
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {

    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: UIImage?
    var uploadImage: (UIImage) -> Void
    
    init(isShown: Binding<Bool>, image: Binding<UIImage?>, uploadImage: @escaping (UIImage) -> Void) {
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
        self.uploadImage = uploadImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageInCoordinator = unwrapImage
        uploadImage(unwrapImage)
        isCoordinatorShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
}
