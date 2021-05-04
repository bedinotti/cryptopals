//
//  Challenge10.swift
//  Cryptopals
//
//  Created by Chris Downie on 5/4/21.
//

import Combine
import CryptoTools
import Foundation

struct Challenge10: Challenge {
    static let id = 10
    let subject = PassthroughSubject<ChallengeUpdate, Error>()
    private let encryptedData: Data
    
    init() {
        let url = Bundle.main.url(forResource: "10", withExtension: "txt")!
        let contents = try! String(contentsOf: url)
        encryptedData = DataDisplay.data(forBase64String: contents.replacingOccurrences(of: "\n", with: ""))!
    }
    
    func run() {
        let key = "YELLOW SUBMARINE".data(using: .utf8)!
        let cipher = AES128CBCCipher(key: key, initializationVector: Data(repeating: 0x00, count: AES128CBCCipher.blockSize))
        // Note: I had to do challenge 15 before this one worked
        let result = cipher.decrypt(data: encryptedData)
        
        let resultDisplay = String(decoding: result, as: UTF8.self)
        update(resultDisplay)
    }
}
