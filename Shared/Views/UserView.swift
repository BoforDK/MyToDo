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
                Image(uiImage: viewModel.image ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                Button(action: {
                            self.viewModel.sourceType = .photoLibrary
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
                Button(action: {
                    self.viewModel.sourceType = .camera
                        self.isShowPhotoLibrary = true
                        }) {
                            HStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 20))
             
                                Text("Camera")
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
                CaptureImageView(isShown: $isShowPhotoLibrary, image: self.$viewModel.image, sourceType: viewModel.sourceType) { image in
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
