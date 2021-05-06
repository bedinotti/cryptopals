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
        struct PartialResult {
            let ciphertext: Data
            let duplicatedBlockCount: Int
        }

        let blockSize = 16
        let partials = input.map { data -> PartialResult in
            var foundBlocks = Set<Data>()
            var duplicatedBlockCount = 0

            for index in stride(from: 0, to: data.count, by: blockSize) {
                let subset = data[index..<min(index+blockSize, data.count)]
                if foundBlocks.contains(subset) {
                    duplicatedBlockCount += 1
                }
                foundBlocks.insert(subset)
            }

            return PartialResult(ciphertext: data, duplicatedBlockCount: duplicatedBlockCount)
        }

        let sortedResult = partials.sorted { left, right in
            left.duplicatedBlockCount > right.duplicatedBlockCount
        }

        let likelyCBC = sortedResult.first!
        update("This is CBC with \(likelyCBC.duplicatedBlockCount)")
        update("repeated blocks: \(DataDisplay.hexString(for: likelyCBC.ciphertext))")
    }
}
