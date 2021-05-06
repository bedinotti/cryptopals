//
//  AES128.swift
//  CryptoTools
//
//  Created by Chris Downie on 5/4/21.
//

import Foundation

public enum AES128 {
    public static let blockSize = 16

    public enum Encoding: CaseIterable {
        case electronicCodebook
        case cipherBlockChaining
    }

    public static func randomKey() -> Data {
        let bytes = (0..<blockSize)
            .map { _ in
                UInt8.random(in: 0...UInt8.max)
            }
        return Data(bytes)
    }
}
