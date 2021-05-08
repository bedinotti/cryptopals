//
//  Challenge16.swift
//  Cryptopals
//
//  Created by Chris Downie on 5/8/21.
//

import Combine
import CryptoTools
import Foundation

struct Challenge16: Challenge {
    static let id = 16
    let subject = PassthroughSubject<ChallengeUpdate, Error>()

    class Server {
        let cipher = AES128.CBCCipher(key: AES128.randomKey(), initializationVector: AES128.randomKey())

        private func dataString(with userData: String) -> String {
            let prefix = "comment1=cooking%20MCs;userdata="
            let suffix = ";comment2=%20like%20a%20pound%20of%20bacon"
            let sanitizedInput = userData
                .replacingOccurrences(of: ";", with: "%3B")
                .replacingOccurrences(of: "=", with: "%3D")

            return prefix + sanitizedInput + suffix
        }

        func encryptedRequest(userData: String) -> Data {
            let string = dataString(with: userData)
            let encryptedResult = try! cipher.encrypt(data: string.data(using: .utf8)!)
            return encryptedResult
        }

        func isEncryptedAdmin(request: Data) -> Bool {
            let decryptedData = try! cipher.decrypt(data: request)
            let string = String(decoding: decryptedData, as: UTF8.self)
            let keyValues = string
                .components(separatedBy: ";")
                .reduce(into: [String: String]()) { dict, stringPair in
                    let pair = stringPair.components(separatedBy: "=")
                    guard pair.count == 2 else {
                        return
                    }
                    let key = pair[0]
                    let value = pair[1]
                    dict[key] = value
                }

            return keyValues["admin"] == "true"
        }
    }

    func run() {
        let server = Server()
        let attackString = ";admin=true;"

        // Let's make sure a naive attack won't work
        let naiveRequest = server.encryptedRequest(userData: attackString)
        let naiveResult = server.isEncryptedAdmin(request: naiveRequest)
        update("Naive attack \(naiveResult ? "did" : "did not") work.")

        func encryptMethod(_ input: Data) -> Data {
            server.encryptedRequest(userData: String(decoding: input, as: UTF8.self))
        }

        // Follow our routine and analyze the method.
        let blockSize = Analysis.detectBlockSize(inMethod: encryptMethod(_:))
        let method = Analysis.detectAESCipher(in: encryptMethod(_:))
        update("This looks like \(method) with block size \(blockSize)")

        let prefixSize = Analysis.detectECBPrefixSize(blockSize: blockSize, encryptionMethod: encryptMethod(_:))
        update("Prefix is \(prefixSize) bytes")

        // Make a block-aligned input, and mask the illegal characters
        // The prefix is block aligned, so we don't need to do anyhing special to adjust
        let byteMask: UInt8 = 0x01
        let attackBlockString = attackString + String(repeating: ";", count: blockSize - attackString.count)
        let maskBlock = attackBlockString.map { letter -> UInt8 in
            if letter == ";" || letter == "=" {
                return byteMask
            } else {
                return 0x00
            }
        }

        // Xor our mask with our input. Use that same mask on the block before our input, and the encryption
        // method should un-mask our attack string.
        let xorCipher = FixedXorCipher(key: Data(maskBlock))
        let maskedInput = xorCipher.encrypt(data: attackBlockString.data(using: .utf8)!)
        var attackOutput = encryptMethod(maskedInput)
        var maskedPriorBlock = attackOutput[blockSize..<2*blockSize]
        maskedPriorBlock = xorCipher.encrypt(data: maskedPriorBlock)
        attackOutput[blockSize..<2*blockSize] = maskedPriorBlock

        // Let's see if it worked.
        let attackedResult = server.isEncryptedAdmin(request: attackOutput)
        update("Bit flipping attack \(attackedResult ? "did" : "did not") work.")
        complete(success: attackedResult)
    }
}
