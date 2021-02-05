//
//  AuthenticationWithEmailAndPassword.swift
//  MyToDo
//
//  Created by Alexander on 2/4/21.
//

import Foundation
import Firebase
import Combine

class AuthenticationWithEmailAndPassword {
//    var email: String
//    var password: String
//    var isGoodResult: (Bool) -> Void
    
//    init(email: String, password: String, isGoodResult: @escaping  (Bool) -> Void) {
//        self.email = email
//        self.password = password
//        self.isGoodResult = isGoodResult
//    }
    
    func signIn(email: String, password: String, isGoodResult: @escaping  (Bool) -> Void) -> AnyPublisher<AuthDataResult, Error> {
        return Future<AuthDataResult, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    isGoodResult(false)
                    return promise(.failure(error))
                } else {
                    guard let authResult = authResult else {
                        isGoodResult(false)
                        fatalError("authResult is nil")
                    }
                    isGoodResult(true)
                    return promise(.success(authResult))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func createUser(email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
        return Future<AuthDataResult, Error> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    return promise(.failure(error))
                } else {
                    guard let authResult = authResult else {
                        fatalError("authResult is nil")
                    }
                    return promise(.success(authResult))
                }
            }
        }.eraseToAnyPublisher()
    }
}
