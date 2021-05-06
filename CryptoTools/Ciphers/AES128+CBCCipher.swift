//
//  AES128+CBCCipher.swift
//  CryptoTools
//
//  Created by Chris Downie on 5/4/21.
//

import Foundation

extension AES128 {
    final public class CBCCipher: Cipher {
        public let encoding = Encoding.cipherBlockChaining
        private var blockSize: Int {
            AES128.blockSize
        }

        private let iv: Data
        private let shouldPadData: Bool
        private let ecbCipher: ECBCipher

        public init(key: Data, initializationVector iv: Data, hasPadding: Bool = true) {
            precondition(key.count == AES128.blockSize)
            precondition(iv.count == AES128.blockSize)

            self.iv = iv
            shouldPadData = hasPadding

            // We do our own padding, so we don't need to use padding with the ECB cipher
            ecbCipher = ECBCipher(key: key, hasPadding: false)
        }

        public func encrypt(data: Data) throws -> Data {
            let dataToEncrypt: Data
            if shouldPadData {
                dataToEncrypt = Padding.pkcs7(data, blockSize: blockSize)
            } else {
                dataToEncrypt = data
            }

            // Make sure we're block-aligned now
            assert(dataToEncrypt.count % blockSize == 0)

            var carryoverToXor = iv
            var encryptedData = Data()
            try stride(from: 0, to: dataToEncrypt.count, by: blockSize)
                .forEach { [ecbCipher] index in
                    let nextBlock = dataToEncrypt[index..<index+blockSize]
                    let xorCipher = FixedXorCipher(key: carryoverToXor)
                    let xordBlock = xorCipher.encrypt(data: nextBlock)
                    let encryptedBlock = try ecbCipher.encrypt(data: xordBlock)
                    encryptedData += encryptedBlock
                    carryoverToXor = encryptedBlock
                }

            return encryptedData
        }

        public func decrypt(data encryptedData: Data) throws -> Data {
            assert(encryptedData.count % blockSize == 0)

            var carryoverToXor = iv
            var decryptedData = Data()
            try stride(from: 0, to: encryptedData.count, by: blockSize)
                .forEach { [ecbCipher] index in
                    let nextBlock = encryptedData[index..<index+blockSize]
                    let decryptedBlock = try ecbCipher.decrypt(data: nextBlock)
                    let xorCipher = FixedXorCipher(key: carryoverToXor)
                    let plaintextBlock = xorCipher.decrypt(data: decryptedBlock)
                    decryptedData += plaintextBlock
                    carryoverToXor = nextBlock
                }

            if shouldPadData {
                decryptedData = try Padding.stripPKCS7(from: decryptedData)
            }
            return decryptedData
        }
    }
}
