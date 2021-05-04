//
//  AES128CBCCipher.swift
//  CryptoTools
//
//  Created by Chris Downie on 5/4/21.
//

import Foundation

final class AES128CBCCipher: Cipher {
    private static let blockSize = 16
    private var blockSize: Int {
        Self.blockSize
    }

    private let iv: Data
    private let shouldPadData: Bool
    private let ecbCipher: AES128ECBCipher
    
    init(key: Data, initializationVector iv: Data, hasPadding: Bool = true) {
        precondition(key.count == Self.blockSize)
        precondition(iv.count == Self.blockSize)
        
        self.iv = iv
        shouldPadData = hasPadding
    
        // We do our own padding, so we don't need to use padding with the ECB cipher
        ecbCipher = AES128ECBCipher(key: key, hasPadding: false)
    }
    
    func encrypt(data: Data) -> Data {
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
        stride(from: 0, to: dataToEncrypt.count, by: blockSize)
            .forEach { [ecbCipher] index in
                let nextBlock = dataToEncrypt[index..<index+blockSize]
                let xorCipher = FixedXorCipher(key: carryoverToXor)
                let xordBlock = xorCipher.encrypt(data: nextBlock)
                let encryptedBlock = ecbCipher.encrypt(data: xordBlock)
                encryptedData += encryptedBlock
                carryoverToXor = encryptedBlock
            }
        
        return encryptedData
    }
    
    func decrypt(data: Data) -> Data {
        Data()
    }
}
