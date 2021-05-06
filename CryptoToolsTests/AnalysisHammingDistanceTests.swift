//
//  AnalysisHammingDistanceTests.swift
//  CryptoToolsTests
//
//  Created by Chris Downie on 4/30/21.
//

import XCTest
@testable import CryptoTools

class AnalysisHammingDistanceTests: XCTestCase {

    func testGivenPhrase() throws {
        let expected = 37
        let output = Analysis.hammingDistanceForUTF8Strings("this is a test", "wokka wokka!!!")

        XCTAssertEqual(output, expected)
    }

    func testSingleBitDistanceInOneByte() throws {
        let expected = 1
        let output = Analysis.hammingDistance(Data([0x04]), Data([0x05]))

        XCTAssertEqual(output, expected)
    }
}
