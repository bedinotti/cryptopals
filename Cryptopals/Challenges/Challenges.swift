//
//  Challenges.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/25/21.
//

import Foundation

var currentChallenge = Challenge04()
var allChallenges = MultipleChallengeRunner(challenges: [
    Challenge01(),
    Challenge02(),
    Challenge03(),
    Challenge04(),
])

protocol Challenge {
    mutating func setup()
    func run()
}

extension Challenge {
    mutating func setupAndRun() {
        setup()
        run()
    }
}

class ChallengeRunner: Challenge {
    private var challenge: Challenge
    init(challenge: Challenge) {
        self.challenge = challenge
    }
    
    func setup() {}

    func run() {
        challenge.setup()
        challenge.run()
    }
}

class MultipleChallengeRunner: Challenge {
    private var challenges: [Challenge]
    init(challenges: [Challenge]) {
        self.challenges = challenges
    }
    
    func setup() {}

    func run() {
        challenges.forEach { challenge in
            var challenge = challenge
            challenge.setupAndRun()
        }
    }
}
