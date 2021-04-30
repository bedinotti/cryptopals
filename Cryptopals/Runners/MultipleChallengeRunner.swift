//
//  MultipleChallengeRunner.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/30/21.
//

import Foundation

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
