//
//  RegistrationViewModel.swift
//  MyToDo
//
//  Created by Alexander on 2/5/21.
//

import Foundation
import Combine

class RegistrationViewModel: ObservableObject {
    @Published var email: String = "Test3@gmail.com"
    @Published var password: String = "12345"
    
    @Published var errorMessage = ""
    @Published var isError = false
    
    @Published var authSuccessful = false
    
    var setEmailAndPassword: (String, String) -> Void
    
    
    var cancellable: AnyCancellable?
    
    init(setEmailAndPassword: @escaping (String, String) -> Void) {
        self.setEmailAndPassword = setEmailAndPassword
    }
    
    func createUser(finalEmail: String, finalPassword: String, afterCreate: @escaping () -> Void) {
        let authService = AuthenticationWithEmailAndPassword()
        cancellable = authService.createUser(email: finalEmail, password: finalPassword)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                case .finished:
                    self.authSuccessful = true
                    self.setEmailAndPassword(finalEmail, finalPassword)
                    afterCreate()
                }
            }, receiveValue: { _ in })
        
    }
}
