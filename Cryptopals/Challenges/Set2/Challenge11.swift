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
        enum Encoding: CaseIterable {
            case electronicCodeBlock
            case chainBlockCipher
        }
        
        func encrypt(data: Data) -> (Data, Encoding) {
            let encoding = Encoding.allCases.randomElement()!
            return (data, encoding)
        }
    }
    
    func detectCipherMode(for encryptedData: Data) -> Oracle.Encoding {
        .electronicCodeBlock
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
