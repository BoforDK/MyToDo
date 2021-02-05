//
//  Feedback.swift
//  MyToDo
//
//  Created by Alexander on 2/4/21.
//

import Foundation
import Combine

struct Feedback<State, Event> {
    let run: (AnyPublisher<State, Never>) -> AnyPublisher<Event, Never>

    init<Effect: Publisher>(effects: @escaping (State) -> Effect)
        where Effect.Output == Event, Effect.Failure == Never {
        run = { state -> AnyPublisher<Event, Never> in
            state
                .map { effects($0) }
                .switchToLatest()
                .eraseToAnyPublisher()
        }
    }
}

