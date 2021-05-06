//
//  ChallengeRunner.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/30/21.
//

import Combine
import Foundation

class ChallengeRunner {
    var types: [Challenge.Type]
    private let shouldMeasureRuntime: Bool

    private var startTimeInNanoseconds: UInt64?
    private var currentSubscription: AnyCancellable?

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
            let challenge = challengeType.init()
            currentSubscription = challenge.publisher.sink { completion in
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
                startTimeInNanoseconds = DispatchTime.now().uptimeNanoseconds
            } else {
                startTimeInNanoseconds = nil
            }

            challenge.runWithUpdates()
        }
    }

    private func printUpdate(_ update: ChallengeUpdate, id: Int) {
        switch update {
        case .started:
            print("==== Challenge \(id) Started ====")
        case .message(let string):
            print(string)
        case .completed(let success):
            if success {
                print("🎉 Challenge \(id) Success! 🎉")
            } else {
                print("❌ Challenge \(id) failed... ❌")
            }
        case .finished:
            let endTime = DispatchTime.now().uptimeNanoseconds
            if let startTime = startTimeInNanoseconds {
                let nanoseconds = endTime - startTime
                print("==== Challenge \(id) Finished Running in \(formatNanoseconds(nanoseconds)) ====\n")
            } else {
                print("==== Challenge \(id) Finished Running ====\n")
            }
        }
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
