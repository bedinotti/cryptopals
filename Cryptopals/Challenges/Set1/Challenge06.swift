//
//  Challenge06.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/30/21.
//

import Foundation
import CryptoTools

struct Challenge06: Challenge {
    var encryptedData: Data!
    
    mutating func setup() {
        let file = Bundle.main.url(forResource: "6", withExtension: "txt")!
        let contents = try! String(contentsOf: file).replacingOccurrences(of: "\n", with: "")
        encryptedData = DataDisplay.data(forBase64String: contents)!
    }
    
    func run() {
        print("found \(encryptedData.count) bytes to decrypt")
    }
    
    
}
