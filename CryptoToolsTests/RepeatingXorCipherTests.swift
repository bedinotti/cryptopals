//
//  RepeatingXorCipherTests.swift
//  CryptoToolsTests
//
//  Created by Chris Downie on 4/30/21.
//

import XCTest
@testable import CryptoTools

class RepeatingXorCipherTests: XCTestCase {
    func testThreeByteKeyWithMatchingLengthData() throws {
        let key = Data([0x01, 0x02, 0x03])
        let cipher = RepeatingXorCipher(key: key)

        let input = Data(repeating: 0, count: key.count)
        let output = cipher.encrypt(data: input)
        let expected = Data([0x01, 0x02, 0x03])
        
        XCTAssertEqual(output, expected)
    }

    func testThreeByteKeyWithFiveByteData() throws {
        let key = Data([0x01, 0x02, 0x03])
        let cipher = RepeatingXorCipher(key: key)

        let input = Data([0x01, 0x02, 0x03, 0x04, 0x05])
        let output = cipher.encrypt(data: input)
        let expected = Data([0x00, 0x00, 0x00, 0x05, 0x07])
        
        XCTAssertEqual(output, expected)
    }

}
