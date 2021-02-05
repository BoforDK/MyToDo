//
//  SignInWithEmailAndPassword.swift
//  MyToDo
//
//  Created by Alexander on 2/4/21.
//

import Foundation
import Firebase
import Combine
//import

class SignInWithEmailAndPassword {
    var email: String
    var password: String
    var onCommit: (Bool) -> Void
    
    init(email: String, password: String, onCommit: @escaping  (Bool) -> Void) {
        self.email = email
        self.password = password
        self.onCommit = onCommit
    }
    
    func signIn() -> AnyPublisher<AuthDataResult, Error> {
        return Future<AuthDataResult, Error> { promise in
            Auth.auth().signIn(withEmail: self.email, password: self.password) { [weak self] authResult, error in
                if let error = error {
                    self?.onCommit(false)
                    return promise(.failure(error))
                } else {
                    guard let authResult = authResult else {
                        self?.onCommit(false)
                        fatalError("authResult is nil")
                    }
                    self?.onCommit(true)
                    return promise(.success(authResult))
                }
            }
        }.eraseToAnyPublisher()
    }
}
