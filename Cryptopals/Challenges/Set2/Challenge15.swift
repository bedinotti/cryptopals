//
//  Challenge15.swift
//  Cryptopals
//
//  Created by Chris Downie on 5/4/21.
//

import Combine
import CryptoTools
import Foundation

struct Challenge15: Challenge {
    static let id = 15
    let subject = PassthroughSubject<ChallengeUpdate, Error>()
    
    func run() {
        let firstExample  = "ICE ICE BABY".data(using: .utf8)! + Data(repeating: 0x04, count: 4)
        let secondExample = "ICE ICE BABY".data(using: .utf8)! + Data(repeating: 0x05, count: 4)
        let thirdExample  = "ICE ICE BABY".data(using: .utf8)! + Data([0x01, 0x02, 0x03, 0x04])
        
        do {
            let result = try Padding.stripPKCS7(from: firstExample, blockSize: AES128CBCCipher.blockSize)
            let resultString = String(decoding: result, as: UTF8.self)
            let expected = "ICE ICE BABY"
            update("🎉 Valid input decrypted \(resultString == expected ? "correctly" : "incorrectly")")
        } catch Padding.Error.invalidPadding {
            update("❌ Valid input failed with invalid padding error.")
        } catch {
            update("❌ Valid input had unknown error: \(error)")
        }
        
        do {
            let result = try Padding.stripPKCS7(from: secondExample, blockSize: AES128CBCCipher.blockSize)
            update("❌ Invalid input decrypted to >\(String(decoding: result, as: UTF8.self))<")
        } catch Padding.Error.invalidPadding {
            update("🎉 Invalid input failed with invalid padding error.")
        } catch {
            update("❌ Invalid input had unknown error: \(error)")
        }
        
        do {
            let result = try Padding.stripPKCS7(from: thirdExample, blockSize: AES128CBCCipher.blockSize)
            update("❌ Second invalid input decrypted to >\(String(decoding: result, as: UTF8.self))<")
        } catch Padding.Error.invalidPadding {
            update("🎉 Second invalid input failed with invalid padding error.")
        } catch {
            update("❌ Second invalid input had unknown error: \(error)")
        }
    }
}
