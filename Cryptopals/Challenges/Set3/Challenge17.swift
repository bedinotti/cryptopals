//
//  Challenge17.swift
//  Cryptopals
//
//  Created by Chris Downie on 5/8/21.
//

import Combine
import CryptoTools
import Foundation

struct Challenge17: Challenge {
    static let id = 17
    let subject = PassthroughSubject<ChallengeUpdate, Error>()

    func run() {
        complete(success: false)
    }
}
