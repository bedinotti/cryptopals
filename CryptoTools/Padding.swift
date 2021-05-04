//
//  Padding.swift
//  CryptoTools
//
//  Created by Chris Downie on 5/2/21.
//

import Foundation

public enum Padding {
    public enum Error: Swift.Error {
        case invalidPadding
    }
    
    public static func pkcs7(_ input: Data, blockSize: Int) -> Data {
        let remainder = input.count % blockSize
        let paddingSize = blockSize - remainder
        var result = input
        result.append(Data(repeating: UInt8(paddingSize), count: paddingSize))
        return result
    }
    
    public static func stripPKCS7(from data: Data, blockSize: Int) throws -> Data {
        guard let paddingSize = data.last else {
            throw Error.invalidPadding
        }
        
        // validate
        let start = data.count - Int(paddingSize)
        guard start >= 0 else {
            throw Error.invalidPadding
        }
        for byte in data[start...] {
            guard byte == paddingSize else {
                throw Error.invalidPadding
            }
        }

        return data.dropLast(Int(paddingSize))
    }
}
