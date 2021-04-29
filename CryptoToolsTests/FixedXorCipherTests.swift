//
//  FixedXorCipherTests.swift
//  CryptoToolsTests
//
//  Created by Chris Downie on 4/28/21.
//

import XCTest
@testable import CryptoTools

class FixedXorCipherTests: XCTestCase {
    func testSingleByteFixedXorCipher() throws {
        let key = Data([0xf0])
        let cipher = FixedXorCipher(key: key)
        
        let input = Data([0x3c])
        let expected = Data([0xcc])
        let output = cipher.encrypt(data: input)
        
        XCTAssertEqual(output, expected)
    }
}
