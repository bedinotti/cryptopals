//
//  Challenge04.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/29/21.
//

import Foundation
import CryptoTools

struct Challenge04: Challenge {
    static let id = 4
    private let input: [Data]
    
    init() {
        let url = Bundle.main.url(forResource: "4", withExtension: "txt")!
        let hexFile = try! String(contentsOf: url)
        input = hexFile
            .components(separatedBy: .newlines)
            .map { hexString in
                DataDisplay.data(forHexString: hexString)!
            }
    }
    
    private struct PartialResult {
        let key: UInt8
        let ciphertext: Data
        let plaintext: String
        let score: Double
    }
    
    func run() {
        let bestScores = input.map { (data: Data) -> PartialResult in
            let result = (0...UInt8.max)
                .map { keyCharacter in
                    let key = Data(repeating: keyCharacter, count: data.count)
                    let cipher = FixedXorCipher(key: key)
                    let decrypted = cipher.decrypt(data: data)
                    let string = String(decoding: decrypted, as: UTF8.self)
                    let scored = Analysis.englishScore(for: string)
                    return PartialResult(key: keyCharacter,
                                         ciphertext: data,
                                         plaintext: string,
                                         score: scored)
                }
                .reduce(nil) { (previous: PartialResult?, current: PartialResult) in
                    guard let previous = previous else {
                        return current
                    }
                    if previous.score >= current.score {
                        return previous
                    } else {
                        return current
                    }
                }
            return result!
        }
        
        let bestPartialResult = bestScores.reduce(nil) { (previous: PartialResult?, current: PartialResult) in
            guard let previous = previous else {
                return current
            }
            if previous.score >= current.score {
                return previous
            } else {
                return current
            }
        }
        
        let result = bestPartialResult!
        print("Challenge 4: 0x\(String(result.key, radix: 16)) decodes one line to: \(result.plaintext)")
    }
}
