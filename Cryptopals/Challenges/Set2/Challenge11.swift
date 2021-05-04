//
//  Challenge11.swift
//  Cryptopals
//
//  Created by Chris Downie on 5/4/21.
//

import Foundation

import Combine
import CryptoTools
import Foundation

struct Challenge11: Challenge {
    static let id = 11
    let subject = PassthroughSubject<ChallengeUpdate, Error>()
    
    class Oracle {
        private let cipher: Cipher
        private let encoding: AES128.Encoding
        init() {
            let key = AES128.randomKey()
            encoding = AES128.Encoding.allCases.randomElement()!
            switch encoding {
            case .electronicCodebook:
                cipher = AES128.ECBCipher(key: key)
            case .cipherBlockChaining:
                cipher = AES128.CBCCipher(key: key, initializationVector: AES128.randomKey())
            }
        }
        
        func encrypt(data: Data) -> (Data, AES128.Encoding) {
            return (data, encoding)
        }
    }
    
    func detectCipherMode(for encryptedData: Data) -> AES128.Encoding {
        .electronicCodebook
    }
    
    func run() {
        let runCount = 10
        let dataToEncrypt = Data(repeating: 0x00, count: 64)
        
        var allCorrect = true
        (0..<runCount)
            .forEach { attemptCount in
                let oracle = Oracle()
                let examplePair = oracle.encrypt(data: dataToEncrypt)
                let guess = detectCipherMode(for: examplePair.0)
                let didGuessCorrectly = guess == examplePair.1
                let icon = didGuessCorrectly ? "🎉" : "❌"
                update("\(icon) Run \(attemptCount): Oracle encrypted in \(examplePair.1) and we guessed \(guess)")
                
                allCorrect = allCorrect && didGuessCorrectly
            }
        
        complete(success: allCorrect)
    }
}
