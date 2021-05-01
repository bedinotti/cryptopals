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
    private var runtimeInNanoseconds: UInt64?
    
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
            let challengeID = challengeType.id
            print("==== Challenge \(challengeID) ===")
            let challenge = challengeType.init()
            let subscription = challenge.publisher.sink { completion in
                switch completion {
                case .finished:
                    self.printUpdate(.finished, id: challengeID)
                case .failure(let error):
                    // TODO: What should I do here?
                    print("\(challengeID) failed with error: \(error)")
                }
            } receiveValue: { update in
                self.printUpdate(update, id: challengeID)
            }

            if shouldMeasureRuntime {
                runtimeInNanoseconds = measure {
                    challenge.run()
                }
            } else {
                runtimeInNanoseconds = nil
                challenge.run()
            }
        }
    }
    
    private func printUpdate(_ update: ChallengeUpdate, id: Int) {
        switch update {
        case .started:
            print("==== Challenge \(id) Started ===")
        case .message(let string):
            print(string)
        case .completed(let success):
            if success {
                print("🎉 Challenge \(id) Success! 🎉")
            } else {
                print("❌ Challenge \(id) failed... ❌")
            }
        case .finished:
            if let nanoseconds = runtimeInNanoseconds {
                print("==== Challenge \(id) Finished Running in \(formatNanoseconds(nanoseconds)) ===\n")
            } else {
                print("==== Challenge \(id) Finished Running ===\n")
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
