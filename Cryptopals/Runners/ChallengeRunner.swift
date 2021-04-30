//
//  ChallengeRunner.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/30/21.
//

import Foundation

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
