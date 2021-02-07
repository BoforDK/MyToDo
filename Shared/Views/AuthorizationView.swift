//
//  AuthorizationView.swift
//  MyToDo
//
//  Created by Alexander on 2/4/21.
//

import SwiftUI

struct AuthorizationView: View {
    @ObservedObject var viewModel: AuthorizationViewModel
    @State var isPresented = false
    @State var errorAuth = false
//    var event: (String, String) -> Void

    let lightGreyColor = Color(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, opacity: 0.6)
    var accentColor: Color = Color(red: 125/255, green: 63/255, blue: 98/255)

    var body: some View {
        ZStack {
            VStack {
                welcomeText
                
                userEmail
                
                userPassword
                
                if (errorAuth) {
                    Text("error auth")
                }
                
                Toggle(isOn: $viewModel.autoLogin) {
                    Text("Auto authorization?")
                }
                .padding()
                .foregroundColor(accentColor)
                
                loginBtn
                
                createNewAccount
            }
        }
        .padding()
        .navigationBarHidden(true)
        .sheet(isPresented: $isPresented) {
            RegistrationView(viewModel: RegistrationViewModel(setEmailAndPassword: { email, password in
                isPresented.toggle()
                viewModel.email = email
                viewModel.password = password
            }))
//            RegistrationView(viewModel: RegistrationViewModel(dimmis: {
//                isPresented.toggle()
//                viewModel.email = UserDefaults.standard.string(forKey: "email") ?? ""
//                viewModel.password = UserDefaults.standard.string(forKey: "password") ?? ""
//            }))
        }
    }

    var welcomeText: some View {
        Text("Welcome!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }

    var userImage: some View {
        Image("userImage")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 75)
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
            if viewModel.isShowingPassword {
                TextField("Password", text: $viewModel.password)
            } else {
                SecureField("Password", text: $viewModel.password)
            }

            Button(action: {
                self.viewModel.isShowingPassword.toggle()
            }) {
                Image(systemName: self.viewModel.isShowingPassword ?
                        "eye.fill"
                        :
                        "eye.slash.fill")
                    .accentColor(accentColor)
            }
        }
        .padding()
        .background(lightGreyColor)
        .cornerRadius(5.0)
        .padding(.bottom, 20)
    }
 
    var loginBtn: some View {
        Button(action: {
            self.viewModel.sendLoginEvent(viewModel.email, viewModel.password)
        }) {
            Text("LOGIN")
                .font(.headline)
                .foregroundColor(Color.white)
                .padding()
                .frame(width: 220, height: 60)
//                .background(Color.green)
                .background(accentColor)
                .cornerRadius(15.0)
        }
    }
    
    var createNewAccount: some View {
//        NavigationView {
//            NavigationLink(destination: RegistrationView(viewModel: RegistrationViewModel()), label: {
//                Text("Create new account")
//                    .font(.headline)
//            })
//        }
        Button(action: {
            isPresented.toggle()
        }) {
            Text("Create new account")
                .font(.headline)
        }
    }
}

