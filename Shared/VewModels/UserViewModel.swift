//
//  UserViewModel.swift
//  MyToDo
//
//  Created by Alexander on 2/5/21.
//

import Foundation

class UserViewModel: ObservableObject {
    var logout: () -> Void
    
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
    
    init(logout: @escaping () -> Void) {
        self.logout = logout
    }
}
