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
    ]

    // From http://www.viviancook.uk/Punctuation/PunctFigs.htm
    // swiftlint:disable colon
    static let englishPunctuationScore: [Character: Double] = [
        ".":  65.3 / 1000,
        ",":  61.6 / 1000,
        ";":   3.2 / 1000,
        ":":   3.4 / 1000,
        "!":   3.3 / 1000,
        "?":   5.6 / 1000,
        "'":  24.3 / 1000,
        "\"": 26.7 / 1000,
        "-":  15.3 / 1000,
        " ": 100.0 / 1000,
    ]
    // swiftlint:enable colon

    /// Analyze the given text and return a score based on how much the text looks like normal English.
    /// This is a relative score -- the value is irrelevant on its own, but is useful when compared to other
    /// texts scored with this same function.
    /// - Parameter text: The text to score
    /// - Returns: A number representing how English the text is. Higher scores are better.
    public static func englishScore(for text: String) -> Double {
        var characterFrequencies = [Character: Double]()

        // Accumulate character counts
        text.forEach { letter in
            let currentCount = characterFrequencies[letter, default: 0]
            characterFrequencies[letter] = currentCount + 1
        }

        // Divide by total characters
        characterFrequencies.forEach { (key: Character, value: Double) in
            characterFrequencies[key] = value / Double(text.count)
        }

        let perfectScore = 100.0
        func letterScore(expectedFrequency: Double, actualFrequency: Double) -> Double {
            max(perfectScore - pow(abs(expectedFrequency - actualFrequency), 1.2), 0)
        }

        let letterScoreSum = englishLetterScore.reduce(0.0) { sum, pair in
            let actualFrequency = characterFrequencies[pair.key, default: 0.0]
            return sum + letterScore(expectedFrequency: pair.value, actualFrequency: actualFrequency)
        }

        let punctuationScoreSum = englishPunctuationScore.reduce(0.0) { sum, pair in
            let actualFrequency = characterFrequencies[pair.key, default: 0.0]
            return sum + letterScore(expectedFrequency: pair.value, actualFrequency: actualFrequency)
        }

        return letterScoreSum + punctuationScoreSum
    }

    /// Compute the number of bits that differ between the two data objects
    /// - Parameters:
    ///   - from: The first data object to compare
    ///   - to: The second data object to compare
    /// - Returns: The number of bits that are different between them.
    public static func hammingDistance(_ from: Data, _ to: Data) -> Int {
        assert(from.count == to.count)
        let difference = zip(from, to)
            .map { pair -> Int in
                let diffBits: UInt8 = pair.0 ^ pair.1
                var sum: UInt8 = 0
                (0..<UInt8(8)).forEach { shiftBy in
                    sum += (diffBits >> shiftBy) & 0x01
                }
                return Int(sum)
            }
            .reduce(0, +)
        return difference
    }

    /// Compute the number of bits that differ between two UTF8 strings.
    /// - Parameters:
    ///   - from: A UTF8 String
    ///   - to: A UTF8 String
    /// - Returns: The number of bits that are different between the two strings when encoded as UTF8 bytes.
    public static func hammingDistanceForUTF8Strings(_ from: String, _ to: String) -> Int {
        let fromData = from.data(using: .utf8)!
        let toData = to.data(using: .utf8)!
        return hammingDistance(fromData, toData)
    }

    /// Guess the block size for a single piece of encrypted data.
    ///
    /// If you have access to the encryption method used, prefer `detectBlockSize(inMethod:)`
    /// - Parameter encryptedData: The data that has been (presumably) encoded with a block cipher
    /// - Returns: The most likely size of the block in bytes.
    public static func guessBlockSize(in encryptedData: Data) -> Int {
        struct PartialResult {
            let blockSize: Int
            let averageHammingDistance: Double
        }

        let results = (2...40)
            .map { blockBytes -> PartialResult in
                let firstBlock  = encryptedData[           0 ..<   blockBytes]
                let secondBlock = encryptedData[  blockBytes ..< 2*blockBytes]
                let thirdBlock  = encryptedData[2*blockBytes ..< 3*blockBytes]
                let fourthBlock = encryptedData[3*blockBytes ..< 4*blockBytes]
                let fifthBlock  = encryptedData[4*blockBytes ..< 5*blockBytes]

                let pairs = [
                    (firstBlock, secondBlock),
                    (firstBlock, thirdBlock),
                    (firstBlock, fourthBlock),
                    (firstBlock, fifthBlock),
                    (secondBlock, thirdBlock),
                    (secondBlock, fourthBlock),
                    (secondBlock, fifthBlock),
                    (thirdBlock, fourthBlock),
                    (thirdBlock, fifthBlock),
                    (fourthBlock, fifthBlock)
                ]

                let sumDistance = pairs
                    .map { (left, right) in
                        Double(Analysis.hammingDistance(left, right))
                    }
                    .reduce(0, +)

                let normalized = sumDistance / Double(blockBytes)

                return PartialResult(blockSize: blockBytes, averageHammingDistance: normalized)
            }

        let smallestScore = results.reduce(results.first!) { previous, current in
            if previous.averageHammingDistance < current.averageHammingDistance {
                return previous
            } else if previous.averageHammingDistance == current.averageHammingDistance {
                if previous.blockSize < current.blockSize {
                    return previous
                } else {
                    return current
                }
            } else {
                return current
            }
        }

        return smallestScore.blockSize
    }

    /// Determine the block size generated by a given block-based encryption method.
    /// - Parameter encryptionMethod: The encryption method to analyze.
    /// - Returns: The size of the blocks used in the encryption method,
    public static func detectBlockSize(inMethod encryptionMethod: (Data) -> Data) -> Int {
        let baseline = encryptionMethod(Data())

        var count = 0
        var variant = baseline
        repeat {
            count += 1
            let newData = Data(repeating: 0x41, count: count)
            variant = encryptionMethod(newData)
        } while variant.count == baseline.count

        return variant.count - baseline.count
    }

    /// Detect the block cipher mode for some encrypted data
    /// - Parameter encryptedData: A piece of (presumably) block-encoded data.
    /// - Returns: The likely encoding used to create the given data.
    public static func detectAESCipher(in encryptedData: Data) -> AES128.Encoding {
        assert(encryptedData.count % AES128.blockSize == 0)

        var isBlockDuplicated = false

        // Assume that a repeated block means it's ECB
        firstBlockLoop: for firstBlockIndex in stride(from: 0, to: encryptedData.count, by: AES128.blockSize) {
            let nextIndex = firstBlockIndex + AES128.blockSize
            let firstBlock = encryptedData[firstBlockIndex..<nextIndex]
            for secondBlockIndex in stride(from: nextIndex, to: encryptedData.count, by: AES128.blockSize) {
                let secondBlock = encryptedData[secondBlockIndex..<secondBlockIndex+AES128.blockSize]
                if firstBlock == secondBlock {
                    isBlockDuplicated = true
                    break firstBlockLoop
                }
            }
        }

        if isBlockDuplicated {
            return .electronicCodebook
        } else {
            return .cipherBlockChaining
        }
    }

    public static func detectAESCipher(in encryptionMethod: (Data) -> Data) -> AES128.Encoding {
        // Smallest input to get a repeatd ECB block is 3x block size. If a block was 4 characters:
        // Best Case: Multiple repeated blocks
        // AAAA AAAA AAAA
        // Worst Case: Consumed with early and late padding
        // XAAA AAAA AAAA A

        let repeatedInput = Data(repeating: 0x41, count: AES128.blockSize * 3)
        let encryptedData = encryptionMethod(repeatedInput)
        return detectAESCipher(in: encryptedData)
    }

    /// Determine how many bytes are prepended to input sent to the encryption method.
    /// While we can't detect what the bytes are, we can detect how many exist.
    /// - Parameters:
    ///   - blockSize: The block size used by the encryption method
    ///   - encryptionMethod: The method that performs the encryption
    /// - Returns: The number of bytes prepended to our input.
    public static func detectECBPrefixSize(blockSize: Int, encryptionMethod: (Data) -> Data) -> Int {
        let baselineResult = encryptionMethod(Data())
        let oneByteResult = encryptionMethod(Data(repeating: 0x00, count: 1))

        func doBlocksMatch(blockIndex: Int, _ left: Data, _ right: Data) -> Bool {
            let range = blockSize*blockIndex..<(blockSize*blockIndex + blockSize)
            return left[range] == right[range]
        }

        // Find out which block changed
        var changingBlockIndex = 0
        while doBlocksMatch(blockIndex: changingBlockIndex, baselineResult, oneByteResult) {
            changingBlockIndex += 1
        }

        // Add one byte at a time until that block stops changing
        var addedByteCount = 1
        var previousResult = oneByteResult
        var currentResult = oneByteResult
        repeat {
            addedByteCount += 1
            previousResult = currentResult
            currentResult = encryptionMethod(Data(repeating: 0x41, count: addedByteCount))
        } while !doBlocksMatch(blockIndex: changingBlockIndex, previousResult, currentResult)

        // Calculate how large the block prefix is. We had to go one over to get the blocks to match
        let prefixInBlockCount = blockSize - addedByteCount + 1

        return changingBlockIndex * blockSize + prefixInBlockCount
    }

    /// Detect the bytes that are appended to our inputs to a given encryption method.
    /// - Parameters:
    ///   - blockSize: The block size of the ECB encryption method
    ///   - prefixSize: The number of bytes prepended to any inputs to the ECB encryption method
    ///   - encryptionMethod: The ECB encryption method that might add a suffix
    /// - Returns: The bytes that are appended to our input before encrypting.
    public static func detectECBSuffix(blockSize: Int, prefixSize: Int = 0, encryptionMethod: (Data) -> Data) -> Data {
        var discoveredSuffix = Data()

        let prefixBlocks = prefixSize == 0 ? 0 : prefixSize / blockSize + 1
        let maximumSuffixBlocks = (encryptionMethod(Data()).count / blockSize) - prefixBlocks
        
        // Let's add prefix padding before our "unknown last byte" blocks. This will block-align the following input
        // In the event there is no prefix, or the prefix is block-aligned, we'll add a full block of prefix padding.
        let prefixPadding = Data(repeating: 0, count: blockSize - (prefixSize % blockSize))

        // For every block in the suffix ...
        blockLoop: for suffixBlockOffset in 0..<maximumSuffixBlocks {
            let blockOffset = suffixBlockOffset + prefixBlocks
            var discoveredBlock = Data()
            // ... go byte-by-byte ...
            for byteOffsetInBlock in 0..<blockSize {
                let unknownLastByte = Data(repeating: 0x41, count: blockSize - 1 - byteOffsetInBlock)
                let encryptedInput = encryptionMethod(prefixPadding + unknownLastByte)
                var didDiscoverMatchingByte = false
                // ... and guess all possible next bytes
                for possibleLastByte in 0...UInt8.max {
                    let knownLastByte = unknownLastByte + discoveredSuffix + discoveredBlock + [possibleLastByte]
                    let encryptedBlockWithKnownByte = encryptionMethod(prefixPadding + knownLastByte)

                    let range = (blockOffset * blockSize)..<(blockOffset * blockSize + blockSize)
                    if encryptedBlockWithKnownByte[range] == encryptedInput[range] {
                        discoveredBlock.append(possibleLastByte)
                        didDiscoverMatchingByte = true
                        break
                    }
                }

                // If we weren't able to guess the next byte, then previous bytes have changed. We're likely in
                // the padding, and have completely discovered the suffix.
                if !didDiscoverMatchingByte {
                    discoveredSuffix.append(discoveredBlock)
                    break blockLoop
                }
            }
            discoveredSuffix.append(discoveredBlock)
        }

        // We can guess one byte of pkcs#7 padding, but then adding additional inputs will change the repeated value
        // in the padding. When we've successfully finished determining our suffix, let's remove the last byte, since
        // it's padding and not content.
        _ = discoveredSuffix.removeLast()

        return discoveredSuffix
    }
}
