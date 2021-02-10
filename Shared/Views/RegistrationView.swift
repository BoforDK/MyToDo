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

    let lightGreyColor = Color(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, opacity: 0.6)
    var accentColor: Color = .blue

    var body: some View {
        ZStack {
            VStack {
                registrationText
                
                userEmail
                
                userPassword
                
                if (viewModel.isError) {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
                
                
                loginBtn
                
            }
        }
        .padding()
    }

    var registrationText: some View {
        Text("Registration!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }

    var userEmail: some View {
        HStack {
            Image(systemName: "person")
                .foregroundColor(accentColor)
            TextField("Email", text: $viewModel.email)
        }
        .padding()
        .background(lightGreyColor)
        .cornerRadius(5.0)
        .padding(.bottom, 20)
    }
    
    var userPassword: some View {
        HStack {
            Image(systemName: "lock")
                .foregroundColor(accentColor)

            TextField("Password", text: $viewModel.password)

        }
        .padding()
        .background(lightGreyColor)
        .cornerRadius(5.0)
        .padding(.bottom, 20)
    }
 
    var loginBtn: some View {
        Button(action: {
            viewModel.createUser(finalEmail: viewModel.email, finalPassword: viewModel.password){
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("Create user")
                .font(.headline)
                .foregroundColor(Color.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(accentColor)
                .cornerRadius(15.0)
        }
    }
    
    
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(viewModel: RegistrationViewModel(setEmailAndPassword: {_, _ in }))
    }
}
