//
//  Challenge1.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/25/21.
//

import Foundation
import CryptoTools

struct Challenge01: Challenge {
    static let id = 1
    
    func run() {
        let hexString = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
        let expectedBase64 = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
        
        guard let data = DataDisplay.data(forHexString: hexString) else {
            print("Hex string is invalid")
            return
        }
        let result = DataDisplay.base64String(for: data)
        
        if expectedBase64 == result {
            print("🎉 Challenge One Success! 🎉")
        } else {
            print("❌ Encodings did not match. ❌")
        }
    }
}
