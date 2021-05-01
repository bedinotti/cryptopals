//
//  Challenge3.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/29/21.
//

import Combine
import CryptoTools
import Foundation

struct Challenge03: Challenge {
    static let id = 3
    let subject = PassthroughSubject<ChallengeUpdate, Error>()
    
    private struct PartialResult {
        let characterValue: UInt8
        let score: Double
    }
    
    func run() {
        let ciphertext = DataDisplay.data(forHexString: "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736")!
        
        let bestResult = (0...UInt8.max)
            .map { charValue -> PartialResult in
                let cipher = FixedXorCipher(key: Data(repeating: charValue, count: ciphertext.count))
                let decryptedData = cipher.decrypt(data: ciphertext)
                let decryptedString = String(decoding: decryptedData, as: UTF8.self)
                let score = Analysis.englishScore(for: decryptedString)
                
                return PartialResult(characterValue: charValue, score: score)
            }
            .reduce(PartialResult(characterValue: 0, score: -1)) { previousResult, result in
                if previousResult.score >= result.score {
                    return previousResult
                } else {
                    return result
                }
            }
        
        let finalCipher = FixedXorCipher(key: Data(repeating: bestResult.characterValue, count: ciphertext.count))
        let bestDecryption = finalCipher.decrypt(data: ciphertext)
        let bestDecryptionString = String(decoding: bestDecryption, as: UTF8.self)
        
        print("Challenge 3: Decrypted \(bestDecryptionString)")
    }
}
