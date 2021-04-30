//
//  TimedChallengeRunner.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/30/21.
//

import Foundation

class TimedChallengeRunner: Challenge {
    private var challenge: Challenge
    
    init(challenge: Challenge) {
        self.challenge = challenge
    }
    
    func setup() {
        challenge.setup()
    }
    
    func run() {
        let start = DispatchTime.now()
        challenge.run()
        let end = DispatchTime.now()
        let difference = formatNanoseconds(end.uptimeNanoseconds - start.uptimeNanoseconds)
        print("Completed challenge in \(difference)")
    }
    
    private func formatNanoseconds(_ ns: UInt64) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        
        var value = Double(ns)
        let units: String
        switch value {
        case 0..<100:
            units = "ns"
        case 100..<100_000:
            value /= 1_000
            units = "µs"
        case 100_000..<100_000_000:
            value /= 1_000_000
            units = "ms"
        case 100_000_000...:
            value /= 1_000_000_000
            units = "s"
        default:
            units = "ns"
        }
        
        let valString = numberFormatter.string(for: value)!
        return "\(valString)\(units)"
    }
}
