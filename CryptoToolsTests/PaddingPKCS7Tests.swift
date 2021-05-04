//
//  PaddingPKCS7Tests.swift
//  CryptoToolsTests
//
//  Created by Chris Downie on 5/2/21.
//

import XCTest
@testable import CryptoTools

class PaddingPKCS7Tests: XCTestCase {

    func testPaddingWithOneByteShortAdds01() throws {
        let blockSize = 5
        let input = Data(repeating: 0xff, count: blockSize - 1)
        let expected = Data([0xff, 0xff, 0xff, 0xff, 0x01])
        let output = Padding.pkcs7(input, blockSize: blockSize)
        
        XCTAssertEqual(output, expected)
    }

    func testABlockAlignedInputGeneratesAFullBlockOfPadding() throws {
        let blockSize = 4
        let input = Data(repeating: 0xff, count: blockSize)
        let expected = input + Data(repeating: 0x04, count: blockSize)
        let output = Padding.pkcs7(input, blockSize: blockSize)
        
        XCTAssertEqual(output, expected)
    }
}
