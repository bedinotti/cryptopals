//
//  Challenges.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/25/21.
//

import Foundation

protocol Challenge {
    init()
    func run()
}

enum Challenges {
    static let current: Challenge.Type = Challenge07.self
    static let all: [Challenge.Type] = [
        Challenge01.self,
        Challenge02.self,
        Challenge03.self,
        Challenge04.self,
        Challenge05.self,
        Challenge06.self,
        Challenge07.self,
    ]
}
