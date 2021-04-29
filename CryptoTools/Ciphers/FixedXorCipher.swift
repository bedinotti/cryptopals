//
//  FixedXorCipher.swift
//  CryptoTools
//
//  Created by Chris Downie on 4/28/21.
//

import Foundation

class FixedXorCipher: Cipher {
    let key: Data
    
    init(key: Data) {
        self.key = key
    }
    
    func encrypt(data: Data) -> Data {
        precondition(data.count == key.count)
        
        let bytes = zip(data, key)
            .map { (left, right) -> UInt8 in
                left ^ right
            }
        
        return Data(bytes)
    }
    
    func decrypt(data: Data) -> Data {
        encrypt(data: data) // in this case, encrypt and decrypt are identical operations.
    }
}
