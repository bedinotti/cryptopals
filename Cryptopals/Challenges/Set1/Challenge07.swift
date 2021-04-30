//
//  Challenge07.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/30/21.
//

import Foundation
import CryptoTools

struct Challenge07: Challenge {
    var encryptedData: Data!
    
    mutating func setup() {
        let url = Bundle.main.url(forResource: "7", withExtension: "txt")!
        let content = try! String(contentsOf: url)
            .replacingOccurrences(of: "\n", with: "")
        encryptedData = DataDisplay.data(forBase64String: content)!
    }
    
    func run() {
        print("Not implemented")
    }
}
