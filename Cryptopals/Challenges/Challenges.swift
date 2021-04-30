//
//  Challenges.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/25/21.
//

import Foundation

let currentChallenge: Challenge = Challenge03()
let allChallenges = MultipleChallengeRunner(challenges: [
    Challenge01(),
    Challenge02(),
    Challenge03()
])

protocol Challenge {
    func setup()
    func run()
}

extension Challenge {
    func setup() {}

    func setupAndRun() {
        setup()
        run()
    }
}

class ChallengeRunner: Challenge {
    private let challenge: Challenge
    init(challenge: Challenge) {
        self.challenge = challenge
    }
    
    func run() {
        challenge.setup()
        challenge.run()
    }
}

class MultipleChallengeRunner: Challenge {
    private let challenges: [Challenge]
    init(challenges: [Challenge]) {
        self.challenges = challenges
    }
    
    func run() {
        challenges.forEach { challenge in
            challenge.setup()
            challenge.run()
        }
    }
}
