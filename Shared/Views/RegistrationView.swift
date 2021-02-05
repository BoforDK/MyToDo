//
//  RegistrationView.swift
//  MyToDo
//
//  Created by Alexander on 2/5/21.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Section {
            Text("This is form for registration new user")
            TextField("email", text: $viewModel.email)
            TextField("password", text: $viewModel.password)
            Button("Create user", action: {
                viewModel.createUser(finalEmail: viewModel.email, finalPassword: viewModel.password){
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
            if (viewModel.isError) {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(viewModel: RegistrationViewModel(setEmailAndPassword: {_, _ in }))
    }
}
