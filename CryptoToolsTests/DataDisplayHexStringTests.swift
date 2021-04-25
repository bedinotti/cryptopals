//
//  DataDisplayHexStringTests.swift
//  DataDisplayHexStringTests
//
//  Created by Chris Downie on 4/25/21.
//

import XCTest
@testable import CryptoTools

class DataDisplayHexStringTests: XCTestCase {
    
    // MARK: From String to Data
    func testSingleByteHexStringConverts() throws {
        let input = "49"
        let expected = Data([0x49])
        let output = DataDisplay.data(forHexString: input)
        XCTAssertEqual(output, expected)
    }
    
    func testInvalidCharacterReturnsNil() throws {
        let input = "4g"
        let output = DataDisplay.data(forHexString: input)
        XCTAssertNil(output)
    }
    
    func testInvalidLengthReturnsNil() throws {
        let input = "492"
        let output = DataDisplay.data(forHexString: input)
        XCTAssertNil(output)
    }
    
    func testEmptyStringMeansEmptyData() throws {
        let input = ""
        let expected = Data()
        let output = DataDisplay.data(forHexString: input)
        XCTAssertEqual(output, expected)
    }
    
    func testMultiByteHexStringConverts() throws {
        let input = "4927"
        let expected = Data([0x49, 0x27])
        let output = DataDisplay.data(forHexString: input)
        XCTAssertEqual(output, expected)
    }
    
    // MARK: From Data to String
    func testSingleByteArrayConverts() throws {
        let input = Data([0x49])
        let expected = "49"
        let output = DataDisplay.hexString(for: input)
        XCTAssertEqual(output, expected)
    }
    
    func testEmptyDataMeansEmptyString() throws {
        let input = Data()
        let expected = ""
        let output = DataDisplay.hexString(for: input)
        XCTAssertEqual(output, expected)
    }
    
    func testMultiByteDataConverts() throws {
        let input = Data([0x49, 0x27])
        let expected = "4927"
        let output = DataDisplay.hexString(for: input)
        XCTAssertEqual(output, expected)
    }
}
