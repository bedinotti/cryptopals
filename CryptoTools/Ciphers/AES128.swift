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
}
