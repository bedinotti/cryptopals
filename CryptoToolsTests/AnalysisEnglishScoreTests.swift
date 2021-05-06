//
//  AnalysisEnglishScoreTests.swift
//  CryptoToolsTests
//
//  Created by Chris Downie on 4/29/21.
//

import XCTest
@testable import CryptoTools

class AnalysisEnglishScoreTests: XCTestCase {

    func testLowercaseTextIsAHigherScoreThanUppercase() throws {
        let input = "hello world"
        let lowercaseOutput = Analysis.englishScore(for: input.lowercased())
        let uppercaseOutput = Analysis.englishScore(for: input.uppercased())

        XCTAssertGreaterThan(lowercaseOutput, uppercaseOutput)
    }

    func testInputWithSpacesIsHigherThanWithout() throws {
        let noSpacesInput = "hello_world_this_is_an_input_without_spaces"
        let spacesInput = noSpacesInput.replacingOccurrences(of: "_", with: " ")

        let noSpacesOutput = Analysis.englishScore(for: noSpacesInput)
        let spacesOutput = Analysis.englishScore(for: spacesInput)

        XCTAssertGreaterThan(spacesOutput, noSpacesOutput)
    }

}
