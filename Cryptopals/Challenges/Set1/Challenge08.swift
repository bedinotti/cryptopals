//
//  Challenge08.swift
//  Cryptopals
//
//  Created by Chris Downie on 5/2/21.
//

import Combine
import CryptoTools
import Foundation

struct Challenge08: Challenge {
    static let id = 8
    let subject = PassthroughSubject<ChallengeUpdate, Error>()
    
    private let input: [Data]
    init() {
        let url = Bundle.main.url(forResource: "8", withExtension: "txt")!
        let contents = try! String(contentsOf: url)
        input = contents
            .components(separatedBy: .newlines)
            .map { string in
                DataDisplay.data(forHexString: string)!
            }
    }
    
    func run() {
        update("Not implemented yet")
    }
}
