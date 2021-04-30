//
//  Challenges.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/25/21.
//

import Foundation

var currentChallenge = TimedChallengeRunner(challenge: Challenge07())
var allChallenges = MultipleChallengeRunner(challenges: [
    Challenge01(),
    Challenge02(),
    Challenge03(),
    Challenge04(),
    Challenge05(),
    Challenge06(),
    Challenge07(),
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
