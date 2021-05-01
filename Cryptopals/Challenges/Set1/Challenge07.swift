//
//  Challenge07.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/30/21.
//

import Combine
import CryptoTools
import Foundation

struct Challenge07: Challenge {
    static let id = 7
    let subject = PassthroughSubject<ChallengeUpdate, Error>()
    private let encryptedData: Data
    
    init() {
        let url = Bundle.main.url(forResource: "7", withExtension: "txt")!
        let content = try! String(contentsOf: url)
            .replacingOccurrences(of: "\n", with: "")
        encryptedData = DataDisplay.data(forBase64String: content)!
    }
    
    func run() {
        print("Not implemented")
    }
}
