//
//  UserView.swift
//  MyToDo
//
//  Created by Alexander on 2/5/21.
//

import SwiftUI
import UIKit

struct UserView: View {
    @ObservedObject var viewModel: UserViewModel
    @State private var isShowPhotoLibrary = false
    
    var body: some View {
        ScrollView {
            Section {
                Image(uiImage: viewModel.image)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                Button(action: {
                            self.isShowPhotoLibrary = true
                        }) {
                            HStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 20))
             
                                Text("Photo library")
                                    .font(.headline)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.horizontal)
                        }
                Button("Logout", action: {
                    viewModel.logout()
                })
                
                Text("User image")
                Text("Email")
                Text("Setting")
                Text("Change password")
                Text("Change password")
                
            }
            .sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$viewModel.image) { image in
                    viewModel.uploadImage(image)
                }
            }
            .onAppear {
                viewModel.updateImage()
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(viewModel: UserViewModel(logout: {}, storage: FBStorage(uid: "")))
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: UIImage
    
    var uploadImage: (UIImage) -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.uploadImage(parent.selectedImage)
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
