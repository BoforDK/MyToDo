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

    func signIn(email: String, password: String) -> AnyPublisher<AuthDataResult, AuthenticationError> {
        return Future<AuthDataResult, AuthenticationError> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    return promise(.failure(.error(error)))
                } else {
                    guard let authResult = authResult else {
                        return promise(.failure(.invalidDownloadFormat("Result is nil")))
                    }
                    return promise(.success(authResult))
                }
            }
        }.eraseToAnyPublisher()
    }

    func createUser(email: String, password: String) -> AnyPublisher<AuthDataResult, AuthenticationError> {
        return Future<AuthDataResult, AuthenticationError> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    return promise(.failure(.error(error)))
                } else {
                    guard let authResult = authResult else {
                        return promise(.failure(.invalidDownloadFormat("Result is nil")))
                    }
                    return promise(.success(authResult))
                }
            }
        }.eraseToAnyPublisher()
    }

    enum AuthenticationError: Error {
        case error(Error)
        case invalidDownloadFormat(String)
    }
}
