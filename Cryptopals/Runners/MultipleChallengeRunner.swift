//
//  MultipleChallengeRunner.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/30/21.
//

import Foundation

class MultipleChallengeRunner {
    private var types: [Challenge.Type]
    init(types: [Challenge.Type]) {
        self.types = types
    }
    
    func run() {
        types.forEach { challengeType in
            var challenge = challengeType.init()
            challenge.setupAndRun()
        }
    }
}
