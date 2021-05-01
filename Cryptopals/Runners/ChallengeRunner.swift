//
//  ChallengeRunner.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/30/21.
//

import Foundation

class ChallengeRunner {
    private var type: Challenge.Type
    init(challengeType: Challenge.Type) {
        type = challengeType
    }

    func run() {
        var challenge = type.init()
        challenge.setup()
        challenge.run()
    }
}
