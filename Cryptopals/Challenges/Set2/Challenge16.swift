//
//  Challenge16.swift
//  Cryptopals
//
//  Created by Chris Downie on 5/8/21.
//

import Combine
import CryptoTools
import Foundation

struct Challenge16: Challenge {
    static let id = 16
    let subject = PassthroughSubject<ChallengeUpdate, Error>()

    func run() {
        complete(success: false)
    }
}
