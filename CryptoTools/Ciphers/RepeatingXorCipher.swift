//
//  RepeatingXorCipher.swift
//  CryptoTools
//
//  Created by Chris Downie on 4/30/21.
//

import Foundation

public class RepeatingXorCipher: Cipher {
    let key: Data
    init(key: Data) {
        self.key = key
    }
    
    public func encrypt(data: Data) -> Data {
        let bytes = data
            .enumerated()
            .map { pair in
                pair.element ^ key[pair.offset % key.count]
            }
        return Data(bytes)
    }
    
    public func decrypt(data: Data) -> Data {
        // Encrypting and decrypting are identical with XOR
        encrypt(data: data)
    }
}
