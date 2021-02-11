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

    func signIn(email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
        return Future<AuthDataResult, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
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
