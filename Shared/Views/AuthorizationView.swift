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

    let lightGreyColor = Color(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, opacity: 0.6)
    var accentColor: Color = .blue

    var body: some View {
        ZStack {
            VStack {
                welcomeText

                userEmail

                userPassword

                if errorAuth {
                    Text("error auth")
                }

                Toggle(isOn: $viewModel.user.autoLogin) {
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
                viewModel.user.email = email
                viewModel.user.password = password
            }))
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
            TextField("Email", text: $viewModel.user.email)
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
            if viewModel.user.isShowingPassword {
                TextField("Password", text: $viewModel.user.password)
            } else {
                SecureField("Password", text: $viewModel.user.password)
            }

            Button(action: {
                self.viewModel.user.isShowingPassword.toggle()
            }) {
                Image(systemName: self.viewModel.user.isShowingPassword ?
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
            self.viewModel.sendLoginEvent(viewModel.user.email, viewModel.user.password)
        }) {
            Text("LOGIN")
                .font(.headline)
                .foregroundColor(Color.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(accentColor)
                .cornerRadius(15.0)
        }
    }

    var createNewAccount: some View {
        Button(action: {
            isPresented.toggle()
        }) {
            Text("Create new account")
                .font(.headline)
        }
    }
}
