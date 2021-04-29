//
//  Cipher.swift
//  CryptoTools
//
//  Created by Chris Downie on 4/28/21.
//

import Foundation

protocol Cipher {
    func encrypt(data: Data) -> Data
    func decrypt(data: Data) -> Data
}
