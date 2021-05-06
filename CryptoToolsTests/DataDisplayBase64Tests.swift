//
//  DataDisplayBase64Tests.swift
//  CryptoToolsTests
//
//  Created by Chris Downie on 4/25/21.
//

import XCTest
@testable import CryptoTools

class DataDisplayBase64Tests: XCTestCase {

    // MARK: From String to Data
    func testSingleByteBase64StringConverts() throws {
        let input = "TQ=="
        let expected = Data([0x4d])
        let output = DataDisplay.data(forBase64String: input)
        XCTAssertEqual(output, expected)
    }

    func testInvalidCharacterReturnsNil() throws {
        let input = "T$=="
        let output = DataDisplay.data(forBase64String: input)
        XCTAssertNil(output)
    }

    func testInvalidLengthReturnsNil() throws {
        let input = "TQ="
        let output = DataDisplay.data(forBase64String: input)
        XCTAssertNil(output)
    }

    func testEmptyStringMeansEmptyData() throws {
        let input = ""
        let expected = Data()
        let output = DataDisplay.data(forBase64String: input)
        XCTAssertEqual(output, expected)
    }

    func testTwoByteBase64StringConverts() throws {
        let input = "TWE="
        let expected = Data([0x4d, 0x61])
        let output = DataDisplay.data(forBase64String: input)
        XCTAssertEqual(output, expected)
    }

    func testThreeByteBase64StringConverts() throws {
        let input = "TWFu"
        let expected = Data([0x4d, 0x61, 0x6e])
        let output = DataDisplay.data(forBase64String: input)
        XCTAssertEqual(output, expected)
    }

    // MARK: From Data to String
    func testSingleByteArrayConverts() throws {
        let input = Data([0x4d])
        let expected = "TQ=="
        let output = DataDisplay.base64String(for: input)
        XCTAssertEqual(output, expected)
    }

    func testEmptyDataMeansEmptyString() throws {
        let input = Data()
        let expected = ""
        let output = DataDisplay.base64String(for: input)
        XCTAssertEqual(output, expected)
    }

    func testTwoByteDataConverts() throws {
        let input = Data([0x4d, 0x61])
        let expected = "TWE="
        let output = DataDisplay.base64String(for: input)
        XCTAssertEqual(output, expected)
    }

    func testThreeByteDataConverts() throws {
        let input = Data([0x4d, 0x61, 0x6e])
        let expected = "TWFu"
        let output = DataDisplay.base64String(for: input)
        XCTAssertEqual(output, expected)
    }
}
