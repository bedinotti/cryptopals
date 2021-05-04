//
//  Challenge12.swift
//  Cryptopals
//
//  Created by Chris Downie on 5/4/21.
//

import Foundation

import Combine
import CryptoTools
import Foundation

struct Challenge12: Challenge {
    static let id = 12
    let subject = PassthroughSubject<ChallengeUpdate, Error>()
    
    class Oracle {
        private let paddingSuffix = DataDisplay.data(forBase64String: """
        Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkg
        aGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBq
        dXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUg
        YnkK
        """.replacingOccurrences(of: "\n", with: ""))!
        
        let key: Data
        let cipher: AES128.ECBCipher
        init() {
            key = AES128.randomKey()
            cipher = AES128.ECBCipher(key: key)
        }
        
        func encrypt(data: Data) -> Data {
            try! cipher.encrypt(data: data + paddingSuffix)
        }
    }
    
    func run() {
        let oracle = Oracle()
        let blockSize = Analysis.detectBlockSize(inMethod: oracle.encrypt(data:))
        let method = Analysis.detectAESCipher(in: oracle.encrypt(data:))
        update("Block size is \(blockSize), method is \(method)")
    }
}
