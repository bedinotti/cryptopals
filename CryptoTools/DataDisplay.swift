//
//  DataDisplay.swift
//  CryptoTools
//
//  Created by Chris Downie on 4/25/21.
//

import Foundation

/// This namspace has a collection of functions for creating more easy-to-read displays of byte arrays.
/// Foundation provides implementations for these methods, so we're using our own namespace to be sure we're using our own implementation
public enum DataDisplay {
    
    /// Convert a string of 2-digit hexidecimal numbers into a Data object
    /// - Parameter hexString: The hex string to convert
    /// - Returns: Those bytes as a Data object
    public static func data(forHexString hexString: String) -> Data? {
        guard hexString.count % 2 == 0 else {
            return nil
        }
        var bytes = [UInt8]()
        for i in stride(from: 0, to: hexString.count, by: 2) {
            let rangeStart = hexString.index(hexString.startIndex, offsetBy: i)
            let rangeEnd = hexString.index(rangeStart, offsetBy: 2)
            let range = rangeStart..<rangeEnd
            guard let byte = UInt8(hexString[range], radix: 16) else {
                return nil
            }
            bytes.append(byte)
        }
        return Data(bytes)
    }
    
    /// Convert a data object onto a string represention of 2-digit hex bytes
    /// - Parameter data: The data to convert
    /// - Returns: A hex string
    public static func hexString(for data: Data) -> String {
        data
            .map { String($0, radix: 16) }
            .reduce("", +)
    }
    
    
    private static func base64IndexFor(char: Character) -> UInt8? {
        let index: UInt8
        guard let asciiValue = char.asciiValue else {
            return nil
        }
        switch asciiValue {
        case 65...90: // A to Z
            index = char.asciiValue! - Character("A").asciiValue!
        case 97...122: // a to z
            index = 26 + char.asciiValue! - Character("a").asciiValue!
        case 48...57: // 0 to 9
            index = 26 * 2 + char.asciiValue! - Character("0").asciiValue!
        case Character("+").asciiValue:
            index = 62
        case Character("/").asciiValue:
            index = 63
        default:
            return nil
        }
        return index
    }
    
    private static func characterFor(base64Index index: UInt8) -> Character? {
        guard 0 <= index, index <= 63 else {
            return nil
        }
        
        let value: UInt8
        switch index {
        case 0...25:
            value = index + Character("A").asciiValue!
        case 26...51:
            value = (index - 26) + Character("a").asciiValue!
        case 52...61:
            value = (index - 52) + Character("0").asciiValue!
        case 62:
            value = Character("+").asciiValue!
        case 63:
            value = Character("/").asciiValue!
        default:
            fatalError("Invalid Base64 index should have already returned nil")
        }
        
        return Character(Unicode.Scalar(value))
    }

    /// Convert a base64-encoded string into its underlying Data representation
    /// - Parameter base64String: A valid base64-encoded string
    /// - Returns: Those bytes as a Data object. Nil if input is invalid.
    public static func data(forBase64String base64String: String) -> Data? {
        guard base64String.count % 4 == 0 else {
            return nil
        }
        var bytes = [UInt8]()
        for index in stride(from: 0, to: base64String.count, by: 4) {
            let rangeStart = base64String.index(base64String.startIndex, offsetBy: index)
            let rangeEnd = base64String.index(rangeStart, offsetBy: 4)
            let range = rangeStart..<rangeEnd
            let substring = base64String[range]
            
            assert(substring.count == 4)
            
            var indexes = [UInt8]()
            for char in substring {
                if let index = base64IndexFor(char: char) {
                    indexes.append(index)
                } else if char == "=" {
                    continue
                } else {
                    // invalid character, shut it all down.
                    return nil
                }
            }
            
            let memory: UInt32 = indexes
                .enumerated()
                .reduce(UInt32(0)) { (memory, pair) -> UInt32 in
                    let (index, value) = pair
                    let shiftAmount = 6 * (3 - index)
                    return memory | (UInt32(value) << shiftAmount)
                }
            
            bytes.append(UInt8((memory & 0xff0000) >> 16))
            if indexes.count > 2 {
                bytes.append(UInt8((memory & 0x00ff00) >> 8))
            }
            if indexes.count > 3 {
                bytes.append(UInt8(memory & 0x0000ff))
            }
        }
        return Data(bytes)
    }
    
    /// Convert a data object into its base64-encoded String representation
    /// - Parameter data: The data to convert
    /// - Returns: A base64-encoded string
    public static func base64String(for data: Data) -> String {
        var result = ""
        for index in stride(from: 0, to: data.count, by: 3) {
            let rangeStart = data.index(data.startIndex, offsetBy: index)
            let offset = min(data.distance(from: rangeStart, to: data.endIndex), 3)
            let rangeEnd = data.index(rangeStart, offsetBy: offset)
            let range = rangeStart..<rangeEnd
            
            let bytes = data[range]
            assert(bytes.count <= 3)
            
            let memory: UInt32 = bytes
                .enumerated()
                .reduce(UInt32(0)) { (memory, pair) -> UInt32 in
                    let shiftAmount = 8 * (2 - pair.offset)
                    return memory | (UInt32(pair.element) << shiftAmount)
                }
            
            let first  = UInt8((memory & 0xfc0000) >> (6 * 3))
            let second = UInt8((memory & 0x03f000) >> (6 * 2))
            let third  = UInt8((memory & 0x000fc0) >> (6))
            let fourth = UInt8(memory & 0x00003f)
            
            let validCharcters: [UInt8]
            let equalsToAppend: Int
            switch bytes.count {
            case 1:
                validCharcters = [first, second]
                equalsToAppend = 2
            case 2:
                validCharcters = [first, second, third]
                equalsToAppend = 1
            case 3:
                validCharcters = [first, second, third, fourth]
                equalsToAppend = 0
            default:
                fatalError("Data should be a multiple of 3 when encoding to Base64")
            }
            
            result.append(contentsOf: validCharcters.compactMap(characterFor(base64Index:)))
            result.append(contentsOf: String(repeating: "=", count: equalsToAppend))
        }
        return result
    }
}
