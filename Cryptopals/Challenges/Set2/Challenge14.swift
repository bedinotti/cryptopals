//
//  Challenge14.swift
//  Cryptopals
//
//  Created by Chris Downie on 5/8/21.
//

import Combine
import CryptoTools
import Foundation

struct Challenge14: Challenge {
    static let id = 14
    let subject = PassthroughSubject<ChallengeUpdate, Error>()

    class Oracle {
        private let paddingSuffix = DataDisplay.data(forBase64String: """
        Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkg
        aGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBq
        dXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUg
        YnkK
        """.replacingOccurrences(of: "\n", with: ""))!

        let paddingPrefix: Data

        let key: Data
        let cipher: AES128.ECBCipher
        init() {
            key = AES128.randomKey()
            cipher = AES128.ECBCipher(key: key)

            paddingPrefix = Data(
                (0..<Int.random(in: 5...20))
                    .map({ _ in
                        UInt8.random(in: 0...UInt8.max)
                    })
            )
        }

        func encrypt(data: Data) -> Data {
            try! cipher.encrypt(data: paddingPrefix + data + paddingSuffix)
        }
    }

    func run() {
        let oracle = Oracle()
        let blockSize = Analysis.detectBlockSize(inMethod: oracle.encrypt(data:))
        let method = Analysis.detectAESCipher(in: oracle.encrypt(data:))
        update("Block size is \(blockSize), method is \(method)")

        let prefixSize = Analysis.detectECBPrefixSize(blockSize: blockSize, encryptionMethod: oracle.encrypt(data:))
        update("Detected prefix size of \(prefixSize), should be \(oracle.paddingPrefix.count)")
        let suffix = Analysis.detectECBSuffix(blockSize: blockSize,
                                              prefixSize: prefixSize,
                                              encryptionMethod: oracle.encrypt(data:))

        update("Suffix in hex: \(DataDisplay.hexString(for: suffix))")
        update("Suffix in utf: \(String(decoding: suffix, as: UTF8.self))")
    }
}
