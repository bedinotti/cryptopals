//
//  Challenge06.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/30/21.
//

import Foundation
import CryptoTools

struct Challenge06: Challenge {
    var encryptedData: Data!
    
    mutating func setup() {
        let file = Bundle.main.url(forResource: "6", withExtension: "txt")!
        let contents = try! String(contentsOf: file).replacingOccurrences(of: "\n", with: "")
        encryptedData = DataDisplay.data(forBase64String: contents)!
    }
    
    func run() {
        let keySize = Analysis.blockSize(in: encryptedData)
        print("Guessing the key size is \(keySize)")
        
        var blocks = [Data]()
        for index in stride(from: 0, to: encryptedData.count, by: keySize) {
            let data: Data = encryptedData[index..<min(index+keySize, encryptedData.count)]
            blocks.append(data)
        }
        
        var transposedBlocks = [Data]()
        for index in 0..<keySize {
            let bytesAtIndex = blocks.compactMap { block -> UInt8? in
                guard index < block.count else {
                    return nil
                }
                let blockIndex = block.index(block.startIndex, offsetBy: index)
                return block[blockIndex]
            }
            transposedBlocks.append(Data(bytesAtIndex))
        }
        
        struct PartialResult {
            let characterValue: UInt8
            let score: Double
        }
        let likelyKeys = transposedBlocks.map { repeatingXorBlock -> UInt8 in
            let result = (0...UInt8.max)
                .map { keyCharacter in
                    let key = Data(repeating: keyCharacter, count: repeatingXorBlock.count)
                    let cipher = FixedXorCipher(key: key)
                    let decrypted = cipher.decrypt(data: repeatingXorBlock)
                    let string = String(decoding: decrypted, as: UTF8.self)
                    let scored = Analysis.englishScore(for: string)
                    return PartialResult(characterValue: keyCharacter, score: scored)
                }
                .reduce(nil) { (previous: PartialResult?, current: PartialResult) in
                    guard let previous = previous else {
                        return current
                    }
                    if previous.score >= current.score {
                        return previous
                    } else {
                        return current
                    }
                }
            return result!.characterValue
        }
        
        let key = Data(likelyKeys)
        print("I think the key is \(String(decoding: key, as: UTF8.self))")
        
        let finalCipher = RepeatingXorCipher(key: key)
        let decryptedData = finalCipher.decrypt(data: encryptedData)
        
        print("Output:\n\(String(decoding: decryptedData, as: UTF8.self))")
        
    }
    
    
}
