//
//  AES128CBCCipher.swift
//  CryptoTools
//
//  Created by Chris Downie on 5/4/21.
//

import Foundation

final public class AES128CBCCipher: Cipher {
    public static let blockSize = 16
    private var blockSize: Int {
        Self.blockSize
    }

    private let iv: Data
    private let shouldPadData: Bool
    private let ecbCipher: AES128ECBCipher
    
    public init(key: Data, initializationVector iv: Data, hasPadding: Bool = true) {
        precondition(key.count == Self.blockSize)
        precondition(iv.count == Self.blockSize)
        
        self.iv = iv
        shouldPadData = hasPadding
    
        // We do our own padding, so we don't need to use padding with the ECB cipher
        ecbCipher = AES128ECBCipher(key: key, hasPadding: false)
    }
    
    public func encrypt(data: Data) -> Data {
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
    
    public func decrypt(data encryptedData: Data) -> Data {
        assert(encryptedData.count % AES128CBCCipher.blockSize == 0)

        var carryoverToXor = iv
        var decryptedData = Data()
        stride(from: 0, to: encryptedData.count, by: blockSize)
            .forEach { [ecbCipher] index in
                let nextBlock = encryptedData[index..<index+blockSize]
                let decryptedBlock = ecbCipher.decrypt(data: nextBlock)
                let xorCipher = FixedXorCipher(key: carryoverToXor)
                let plaintextBlock = xorCipher.decrypt(data: decryptedBlock)
                decryptedData += plaintextBlock
                carryoverToXor = nextBlock
            }
        
        if shouldPadData {
            do {
                decryptedData = try Padding.stripPKCS7(from: decryptedData, blockSize: 0)
            } catch {
                // We've decrypted something that was supposed to have padding, but it doesn't.
                return Data()
            }
        }
        return decryptedData
    }
}
