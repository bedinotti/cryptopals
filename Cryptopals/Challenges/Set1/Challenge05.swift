//
//  Challenge05.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/30/21.
//

import Foundation
import CryptoTools

struct Challenge05: Challenge {
    mutating func setup() {}
    
    func run() {
        let key = "ICE".data(using: .utf8)!
        let cipher = RepeatingXorCipher(key: key)
        let input = """
        Burning 'em, if you ain't quick and nimble
        I go crazy when I hear a cymbal
        """.data(using: .utf8)!
        
        let expectedHexString = """
        0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272
        a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f
        """.replacingOccurrences(of: "\n", with: "")
        let expected = DataDisplay.data(forHexString: expectedHexString)
        
        let encryptedData = cipher.encrypt(data: input)
        
        if encryptedData == expected {
            print("🎉Challenge Five Completed!🎉")
        } else {
            print("❌ Encrypted output did not match. ❌")
        }
    }
}
