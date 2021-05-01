//
//  Challenges.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/25/21.
//

import Foundation
import Combine

protocol Challenge {
    static var id: Int { get }
    var subject: PassthroughSubject<ChallengeUpdate, Error> { get }

    init()
    func run()
}

extension Challenge {
    var publisher: AnyPublisher<ChallengeUpdate, Error> {
        subject.eraseToAnyPublisher()
    }
    
    func runWithUpdates() {
        subject.send(.started)
        run()
        subject.send(.finished)
    }
    
    func update(_ message: String) {
        subject.send(.message(message))
    }
    
    func complete(success: Bool) {
        subject.send(.completed(success: success))
    }
}

enum ChallengeUpdate {
    case started
    case message(_: String)
    case completed(success: Bool)
    case finished
}

enum Challenges {
    static let current: Challenge.Type = Challenge01.self
    static let all: [Challenge.Type] = [
        Challenge01.self,
        Challenge02.self,
        Challenge03.self,
        Challenge04.self,
        Challenge05.self,
        Challenge06.self,
        Challenge07.self,
    ]
}
