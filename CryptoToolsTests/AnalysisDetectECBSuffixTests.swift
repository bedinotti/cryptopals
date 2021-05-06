//
//  AnalysisDetectECBSuffixTests.swift
//  CryptoToolsTests
//
//  Created by Chris Downie on 5/4/21.
//

import XCTest
@testable import CryptoTools

class AnalysisDetectECBSuffixTests: XCTestCase {

    func testAnEmptySuffix() throws {
        let key = Data(repeating: 0, count: AES128.blockSize)
        let cipher = AES128.ECBCipher(key: key)
        let expected = Data()
        let output = Analysis.detectECBSuffix(blockSize: AES128.blockSize) { data in
            try! cipher.encrypt(data: data)
        }
        
        XCTAssertEqual(output, expected)
    }
    
    func testSingleByteSuffix() throws {
        let key = Data(repeating: 0, count: AES128.blockSize)
        let cipher = AES128.ECBCipher(key: key)
        let suffix = Data([0x42])
        let output = Analysis.detectECBSuffix(blockSize: AES128.blockSize) { data in
            try! cipher.encrypt(data: data + suffix)
        }
        
        XCTAssertEqual(output, suffix)
        
    }
    
    func testMultiByteSuffix() throws {
        let key = Data(repeating: 0, count: AES128.blockSize)
        let cipher = AES128.ECBCipher(key: key)
        let suffix = "HELLO WORLD".data(using: .utf8)!
        let output = Analysis.detectECBSuffix(blockSize: AES128.blockSize) { data in
            try! cipher.encrypt(data: data + suffix)
        }
        
        XCTAssertEqual(output, suffix)
    }
}
