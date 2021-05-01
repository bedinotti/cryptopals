//
//  Challenge1.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/25/21.
//

import Combine
import CryptoTools
import Foundation

struct Challenge01: Challenge {
    static let id = 1
    let subject = PassthroughSubject<ChallengeUpdate, Error>()
    
    func run() {
        let hexString = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
        let expectedBase64 = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
        
        guard let data = DataDisplay.data(forHexString: hexString) else {
            subject.send(.message("Hex string is invalid"))
            return
        }
        let result = DataDisplay.base64String(for: data)
        
        subject.send(.completed(success: expectedBase64 == result))
        subject.send(completion: .finished)
    }
}
