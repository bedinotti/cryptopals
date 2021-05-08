//
//  Challenge12.swift
//  Cryptopals
//
//  Created by Chris Downie on 5/4/21.
//

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

        let suffix = detectECBSuffix(blockSize: blockSize, encryptionMethod: oracle.encrypt(data:))

        update("Suffix in hex: \(DataDisplay.hexString(for: suffix))")
        update("Suffix in utf: \(String(decoding: suffix, as: UTF8.self))")
    }

    // We're preserving this detectECBSuffix method here, now that the Analysis one has an additional feature.
    private func detectECBSuffix(blockSize: Int, encryptionMethod: (Data) -> Data) -> Data {
        var discoveredSuffix = Data()

        let maximumSuffixBlocks = encryptionMethod(Data()).count / blockSize

        // For every block in the suffix ...
        blockLoop: for blockOffset in 0..<maximumSuffixBlocks {
            var discoveredBlock = Data()
            // ... go byte-by-byte ...
            for byteOffsetInBlock in 0..<blockSize {
                let unknownLastByte = Data(repeating: 0x41, count: blockSize - 1 - byteOffsetInBlock)
                let encryptedInput = encryptionMethod(unknownLastByte)
                var didDiscoverMatchingByte = false
                // ... and guess all possible next bytes
                for possibleLastByte in 0...UInt8.max {
                    let knownLastByte = unknownLastByte + discoveredSuffix + discoveredBlock + [possibleLastByte]
                    let encryptedBlockWithKnownByte = encryptionMethod(knownLastByte)

                    let range = (blockOffset * blockSize)..<(blockOffset * blockSize + blockSize)
                    if encryptedBlockWithKnownByte[range] == encryptedInput[range] {
                        discoveredBlock.append(possibleLastByte)
                        didDiscoverMatchingByte = true
                        break
                    }
                }

                // If we weren't able to guess the next byte, then previous bytes have changed. We're likely in
                // the padding, and have completely discovered the suffix.
                if !didDiscoverMatchingByte {
                    discoveredSuffix.append(discoveredBlock)
                    break blockLoop
                }
            }
            discoveredSuffix.append(discoveredBlock)
        }

        // We can guess one byte of pkcs#7 padding, but then adding additional inputs will change the repeated value
        // in the padding. When we've successfully finished determining our suffix, let's remove the last byte, since
        // it's padding and not content.
        _ = discoveredSuffix.removeLast()

        return discoveredSuffix
    }
}
