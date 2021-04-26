//
//  Challenges.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/25/21.
//

import Foundation

enum Challenge {
    case one
    
    static let current: () -> Void = ChallengeOne.run
}
