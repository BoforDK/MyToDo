//
//  AuthorizationViewModel.swift
//  MyToDo
//
//  Created by Alexander on 2/4/21.
//

import Foundation
import Combine

class AuthorizationViewModel: ObservableObject {
    @Published var errorAuth = false
    @Published var user: User

    var sendLoginEvent: (String, String) -> Void
    var userRepository = UserRepository()

    private var cancellables = Set<AnyCancellable>()

    init(error: Bool = false, sendLoginEvent: @escaping (String, String) -> Void) {
        self.sendLoginEvent = sendLoginEvent
        user = UserRepository().user
        if user.autoLogin && !error {
            self.sendLoginEvent(user.email, user.password)
        }

        $user
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { user in
                self.userRepository.updateUser(user)
            }
            .store(in: &cancellables)
    }
}
