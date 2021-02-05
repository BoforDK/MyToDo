//
//  AuthorizationViewModel.swift
//  MyToDo
//
//  Created by Alexander on 2/4/21.
//


import Foundation
import Combine

final class MainViewModel: ObservableObject {
    @Published private(set) var state: State = State.authorization
//    @Published var cancellable: AnyCancellable?

    private var bag = Set<AnyCancellable>()

    private let input = PassthroughSubject<Event, Never>()

    init() {
        Publishers.system(initial: state,
                          reduce: reduce,
                          scheduler: RunLoop.main,
                          feedbacks: [
                            whenChecking(),
                            userInput(input: input.eraseToAnyPublisher())
                          ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }

    deinit {
        bag.removeAll()
    }

    func send(event: Event) {
        input.send(event)
    }
    
    func cancelAutoAuth() -> Void {
        UserDefaults.standard.setValue(false, forKey: "autoLogin")
    }
}

// MARK: - Inner Types
extension MainViewModel {
    enum State {
        case authorization
        case checking(String, String)
        case successful
        case error(Error)
    }

    enum Event {
        case onAppear
        case onAccountEntry(String, String)
        case onSuccessful
        case onFailed(Error)
        case onLogout
    }
}

// MARK: - State machine
extension MainViewModel {
    func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .authorization:
            switch event {
            case .onAccountEntry(let email, let password):
                return .checking(email, password)
            default:
                return state
            }
        case .checking(_, _):
            switch event {
            case .onSuccessful:
                return .successful
            case .onFailed(let error):
                return .error(error)
            default:
                return state
            }
        case .error(_):
            switch event {
            case .onAccountEntry(let email, let password):
                return .checking(email, password)
            default:
                return state
            }
        case .successful:
            switch event {
            case .onLogout:
                return .authorization
            default:
                return state
            }
        }
    }
}

// MARK: - Actions
extension MainViewModel {
    
    
    func whenChecking() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            
            guard case .checking(let email, let password) = state else {
                return Empty().eraseToAnyPublisher()
            }
            
            let tmp = AuthenticationWithEmailAndPassword()
            
            return tmp.signIn(email: email, password: password, isGoodResult: { isAuth in
                    print(isAuth)
                })
                .map { _ in Event.onSuccessful }
                .catch { Just(Event.onFailed($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}

