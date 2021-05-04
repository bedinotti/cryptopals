//
//  AES128ECBCipher.swift
//  CryptoTools
//
//  Created by Chris Downie on 4/30/21.
//

import Foundation
import CryptoSwift

public class AES128ECBCipher: Cipher {
    private let aes: AES
    public init(key: Data, hasPadding: Bool = true) {
        aes = try! AES(key: key.bytes, blockMode: ECB(), padding: hasPadding ? .pkcs7 : .noPadding)
    }
    
    public func encrypt(data: Data) throws -> Data {
        let bytes = try aes.encrypt(data.bytes)
        return Data(bytes)
    }
    
    public func decrypt(data: Data) throws -> Data {
        let bytes = try aes.decrypt(data.bytes)
        return Data(bytes)
    }
}
