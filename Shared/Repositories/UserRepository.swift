//
//  UserRepository.swift
//  MyToDo
//
//  Created by Alexander on 2/6/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserRepository: ObservableObject {
    private var email: String = UserDefaults.standard.string(forKey: "email") ?? "test@gmail.com" {
        didSet {
            UserDefaults.standard.setValue(email, forKey: "email")
        }
    }
    private var password: String = UserDefaults.standard.string(forKey: "password") ?? "123456" {
        didSet {
            UserDefaults.standard.setValue(password, forKey: "password")
        }
    }
    private var isShowingPassword = UserDefaults.standard.bool(forKey: "isShowingPassword") {
        didSet {
            UserDefaults.standard.setValue(isShowingPassword, forKey: "isShowingPassword")
        }
    }
    private var autoLogin: Bool = UserDefaults.standard.bool(forKey: "autoLogin") {
        didSet {
            UserDefaults.standard.setValue(autoLogin, forKey: "autoLogin")
        }
    }

    private var uid = Auth.auth().currentUser?.uid ?? ""

    var user: User {
        User(email: email,
             password: password,
             isShowingPassword: isShowingPassword,
             autoLogin: autoLogin,
             uid: uid)
    }

    init() {

    }

    func updateUser(_ newUser: User) {
        self.email = newUser.email
        self.password = newUser.password
        self.isShowingPassword = newUser.isShowingPassword
        self.autoLogin = newUser.autoLogin
        self.uid = newUser.uid
    }
}
