//
//  Analysis.swift
//  CryptoTools
//
//  Created by Chris Downie on 4/29/21.
//

import Foundation

public class Analysis {
    // From https://en.wikipedia.org/wiki/Letter_frequency
    static let englishLetterScore: [Character: Double] = [
        "a": 8.2,
        "b": 1.5,
        "c": 2.8,
        "d": 4.3,
        "e": 13.0,
        "f": 2.2,
        "g": 2.0,
        "h": 6.1,
        "i": 7,
        "j": 0.15,
        "k": 0.77,
        "l": 4,
        "m": 2.4,
        "n": 6.7,
        "o": 7.5,
        "p": 1.9,
        "q": 0.095,
        "r": 6,
        "s": 6.3,
        "t": 9.1,
        "u": 2.8,
        "v": 0.98,
        "w": 2.4,
        "x": 0.15,
        "y": 2,
        "z": 0.074,
        // add low values for punctuation as well
        " ": 0.05,
        ".": 0.01,
        "?": 0.01,
        ",": 0.01
    ]
    
    /// Analyze the given text and return a score based on how much the text looks like normal English. This is a relative score -- the value is irrelevant on its own, but is useful when compared to other texts scored with this same function.
    /// - Parameter text: The text to score
    /// - Returns: A number representing how English the text is. Higher scores are better.
    public static func englishScore(for text: String) -> Double {
        let capitalMultiplier = 0.9 // value capital letters a little less.
        let score = text
            .map { letter -> Double in
                let multiplier = letter.isUppercase ? capitalMultiplier : 1.0
                let lowercased = Character(letter.lowercased())
                return multiplier * englishLetterScore[lowercased, default: 0.0]
            }
            .reduce(0, +)
        return score
    }
}
