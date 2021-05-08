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
                    let key = pair[0]
                    let value = pair[1]
                    dict[key] = value
                }

            return keyValues["admin"] == "true"
        }
    }

    func run() {
        let server = Server()

        // Let's make sure a naive attack won't work
        let naiveRequest = server.encryptedRequest(userData: ";admin=true;")
        let naiveResult = server.isEncryptedAdmin(request: naiveRequest)
        update("Naive attack \(naiveResult ? "did" : "did not") work.")

    }
}
