//
//  Cipher.swift
//  CryptoTools
//
//  Created by Chris Downie on 4/28/21.
//

import Foundation

public protocol Cipher {
    func encrypt(data: Data) throws -> Data
    func decrypt(data: Data) throws -> Data
}
