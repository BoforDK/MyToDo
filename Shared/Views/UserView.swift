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
            Image(uiImage: viewModel.image ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 200.0, height: 200.0, alignment: .center)
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                cameraButton
                Spacer()
                libraryButton
            }
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(20)
            .padding(.horizontal)
            
            logout
            
        }
        .navigationBarTitle("User")
        .sheet(isPresented: $isShowPhotoLibrary) {
            CaptureImageView(isShown: $isShowPhotoLibrary, image: self.$viewModel.image, sourceType: viewModel.sourceType) { image in
                viewModel.uploadImage(image)
            }
        }
        .onAppear {
            viewModel.updateImage()
        }
    }
    
    var libraryButton: some View {
        Button(action: {
                    self.viewModel.sourceType = .photoLibrary
                    self.isShowPhotoLibrary = true
                }) {
                    HStack {
                        Text("Library")
                            .font(.headline)
                        
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 60)
                }
    }
    
    var cameraButton: some View {
        Button(action: {
            self.viewModel.sourceType = .camera
                self.isShowPhotoLibrary = true
                }) {
                    HStack {
                        Image(systemName: "camera")
                            .font(.system(size: 20))
     
                        Text("Camera")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 60)
                }
    }
    
    var logout: some View {
        Button(action: {
            viewModel.logout()
        }) {
            Text("Logout")
                .foregroundColor(.blue)                
        }
    }
}


struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(viewModel: UserViewModel(logout: {}, storage: FBStorage(uid: "")))
    }
}
