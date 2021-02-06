//
//  UserRepository.swift
//  MyToDo
//
//  Created by Alexander on 2/6/21.
//

import Foundation

// TODO: not used yet
class UserRepository: ObservableObject {
    @Published var email: String = UserDefaults.standard.string(forKey: "email") ?? "test@gmail.com" {
        didSet {
            UserDefaults.standard.setValue(email, forKey: "email")
        }
    }
    @Published var password: String = UserDefaults.standard.string(forKey: "password") ?? "123456" {
        didSet {
            UserDefaults.standard.setValue(password, forKey: "password")
        }
    }
    @Published var isShowingPassword = UserDefaults.standard.bool(forKey: "isShowingPassword") {
        didSet {
            UserDefaults.standard.setValue(isShowingPassword, forKey: "isShowingPassword")
        }
    }
    @Published var autoLogin: Bool = UserDefaults.standard.bool(forKey: "autoLogin") {
        didSet {
            UserDefaults.standard.setValue(autoLogin, forKey: "autoLogin")
        }
    }
    
    var user: User {
        User(email: email,
             password: password,
             isShowingPassword: isShowingPassword,
             autoLogin: autoLogin)
    }
    
    
    init() {
        
    }
    
    func updateUser(newUser: User) {
        self.email = newUser.email
        self.password = newUser.password
        self.isShowingPassword = newUser.isShowingPassword
        self.autoLogin = newUser.autoLogin
    }
}
