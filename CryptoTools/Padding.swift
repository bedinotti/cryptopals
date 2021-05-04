//
//  Padding.swift
//  CryptoTools
//
//  Created by Chris Downie on 5/2/21.
//

import Foundation

public enum Padding {
    public static func pkcs7(_ input: Data, blockSize: Int) -> Data {
        let remainder = input.count % blockSize
        let paddingSize = blockSize - remainder
        var result = input
        result.append(Data(repeating: UInt8(paddingSize), count: paddingSize))
        return result
    }
}
