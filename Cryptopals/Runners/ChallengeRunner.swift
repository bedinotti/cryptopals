//
//  ChallengeRunner.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/30/21.
//

import Foundation

class ChallengeRunner {
    var types: [Challenge.Type]
    private let shouldMeasureRuntime: Bool
    
    convenience init(challengeType: Challenge.Type) {
        self.init(challengeTypes: [challengeType])
    }
    
    init(challengeTypes: [Challenge.Type], shouldMeasureRuntime: Bool = true) {
        types = challengeTypes
        self.shouldMeasureRuntime = shouldMeasureRuntime
    }
    
    /// Run all of the challenges
    func run() {
        types.forEach { challengeType in
            let challenge = challengeType.init()
            print("==== Challenge \(challenge.id) ===")
            let nanoseconds: UInt64?
            if shouldMeasureRuntime {
                nanoseconds = measure {
                    challenge.run()
                }
            } else {
                nanoseconds = nil
                challenge.run()
            }
            
            if let nanoseconds = nanoseconds {
                print("==== Challenge \(challenge.id) Finished Running in \(formatNanoseconds(nanoseconds)) ===\n")
            } else {
                print("==== Challenge \(challenge.id) Finished Running ===\n")
            }
        }
    }
    
    /// Execute the closure, and return the number of nanoseconds it takes to run
    /// - Parameter closure: The closure to execute
    /// - Returns: Runtime in nanoseconds
    private func measure(closure: () -> Void) -> UInt64 {
        let start = DispatchTime.now()
        closure()
        let end = DispatchTime.now()
        return end.uptimeNanoseconds - start.uptimeNanoseconds
    }
    
    /// Create a display string for the given nanoseconds
    /// - Parameter ns: The number of nanoseconds to display
    /// - Returns: A nicely formatted display of those nanoseconds.
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
