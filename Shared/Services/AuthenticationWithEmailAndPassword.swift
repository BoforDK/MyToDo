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
                if let message = error?.localizedDescription {
                    return promise(.failure(.errorConnection(message)))
                } else {
                    guard let authResult = authResult else {
                        return promise(.failure(.invalidDownloadFormat))
                    }
                    return promise(.success(authResult))
                }
            }
        }.eraseToAnyPublisher()
    }

    func createUser(email: String, password: String) -> AnyPublisher<AuthDataResult, AuthenticationError> {
        return Future<AuthDataResult, AuthenticationError> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let message = error?.localizedDescription {
                    return promise(.failure(.errorConnection(message)))
                } else {
                    guard let authResult = authResult else {
                        return promise(.failure(.invalidDownloadFormat))
                    }
                    return promise(.success(authResult))
                }
            }
        }.eraseToAnyPublisher()
    }

    enum AuthenticationError: Error {
        case errorConnection(String)
        case invalidDownloadFormat
    }
}
