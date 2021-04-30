//
//  AnalysisBlockSizeTests.swift
//  CryptoToolsTests
//
//  Created by Chris Downie on 4/30/21.
//

import XCTest
@testable import CryptoTools

class AnalysisBlockSizeTests: XCTestCase {
    
    let largeDataToEncrypt = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Interdum velit laoreet id donec ultrices tincidunt. In vitae turpis massa sed elementum tempus egestas sed. Scelerisque viverra mauris in aliquam sem fringilla ut morbi. Aliquam eleifend mi in nulla posuere sollicitudin aliquam ultrices sagittis. In ante metus dictum at tempor commodo. Eros donec ac odio tempor orci dapibus ultrices in iaculis. Amet nisl purus in mollis. Fermentum et sollicitudin ac orci phasellus egestas tellus rutrum. Sed viverra tellus in hac habitasse. Integer malesuada nunc vel risus commodo viverra. Scelerisque purus semper eget duis at. Diam vel quam elementum pulvinar etiam non quam. Vel orci porta non pulvinar neque laoreet suspendisse interdum. Dui accumsan sit amet nulla facilisi morbi tempus iaculis urna. Ut consequat semper viverra nam libero justo laoreet. In iaculis nunc sed augue lacus viverra. Pellentesque habitant morbi tristique senectus et netus et. Mattis vulputate enim nulla aliquet porttitor lacus luctus.

    Porttitor eget dolor morbi non. Pharetra pharetra massa massa ultricies mi quis hendrerit. Dui accumsan sit amet nulla facilisi morbi tempus iaculis. Id nibh tortor id aliquet lectus proin nibh nisl. Leo in vitae turpis massa sed. Dictumst vestibulum rhoncus est pellentesque elit ullamcorper dignissim cras. Est ante in nibh mauris cursus mattis molestie a iaculis. Ornare arcu dui vivamus arcu felis. Sit amet consectetur adipiscing elit ut aliquam purus. Vitae suscipit tellus mauris a. In ornare quam viverra orci sagittis eu volutpat odio. Egestas erat imperdiet sed euismod nisi. Sed felis eget velit aliquet. Enim facilisis gravida neque convallis a cras. Enim lobortis scelerisque fermentum dui faucibus in ornare quam. Nisl rhoncus mattis rhoncus urna. Id neque aliquam vestibulum morbi blandit. Accumsan tortor posuere ac ut. Pellentesque elit eget gravida cum sociis natoque penatibus.
    """.data(using: .utf8)!
    
    func testFourByteKeySize() throws {
        let key = "HELP".data(using: .utf8)!
        let cipher = RepeatingXorCipher(key: key)
        let encryptedData = cipher.encrypt(data: largeDataToEncrypt)
        
        let expected = key.count
        let output = Analysis.blockSize(in: encryptedData)
        
        XCTAssertEqual(output, expected)
    }

    func testSixteenByteKeySize() throws {
        let key = "sixteen candles!".data(using: .utf8)!
        let cipher = RepeatingXorCipher(key: key)
        let encryptedData = cipher.encrypt(data: largeDataToEncrypt)
        
        let expected = key.count
        let output = Analysis.blockSize(in: encryptedData)

        XCTAssertEqual(output, expected)
    }

}
