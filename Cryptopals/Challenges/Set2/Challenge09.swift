//
//  Challenge09.swift
//  Cryptopals
//
//  Created by Chris Downie on 5/2/21.
//

import Combine
import CryptoTools
import Foundation

struct Challenge09: Challenge {
    static let id = 9
    let subject = PassthroughSubject<ChallengeUpdate, Error>()

    func run() {
        let input = "YELLOW SUBMARINE".data(using: .utf8)!
        let expected = input + Data(repeating: 0x04, count: 4)
        let output = Padding.pkcs7(input, blockSize: 20)

        complete(success: output == expected)
    }
}
