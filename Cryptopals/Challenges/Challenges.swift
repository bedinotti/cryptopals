//
//  Challenges.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/25/21.
//

import Foundation

enum Challenge {
    case one
}

enum ChallengeSet {
    case one
    
    var challenges: [Challenge] {
        switch self {
        case .one:
            return [.one]
        }
    }
}
