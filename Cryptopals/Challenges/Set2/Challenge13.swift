//
//  Challenge13.swift
//  Cryptopals
//
//  Created by Chris Downie on 5/6/21.
//

import Combine
import CryptoTools
import Foundation

struct Challenge13: Challenge {
    static let id = 13
    let subject = PassthroughSubject<ChallengeUpdate, Error>()

    struct Profile: Codable {
        let email: String
        let uid: Int
        let role: String
    }

    class Server {
        let cipher: AES128.ECBCipher
        init() {
            cipher = AES128.ECBCipher(key: AES128.randomKey())
        }

        private func profileFor(email: String) -> String {
            let encodedEmail = email
                .replacingOccurrences(of: "&", with: "")
                .replacingOccurrences(of: "=", with: "")
            return "email=\(encodedEmail)&uid=10&role=user"
        }

        private func parse(queryString: String) -> Profile? {
            let components = URLComponents(string: "?\(queryString)")
            let email = components?.queryItems?.first(where: { item in
                item.name == "email"
            })
            let uid = components?.queryItems?.first(where: { item in
                item.name == "uid"
            })
            let role = components?.queryItems?.first(where: { item in
                item.name == "role"
            })

            if let email = email?.value,
               let uidString = uid?.value,
               let uid = Int(uidString),
               let role = role?.value {
                return Profile(email: email, uid: uid, role: role)
            } else {
                return nil
            }
        }

        func createProfile(encryptedRequest: Data) throws -> Profile? {
            let decryptedRequest = try cipher.decrypt(data: encryptedRequest)
            let queryString = String(decoding: decryptedRequest, as: UTF8.self)
            let profile = parse(queryString: queryString)
            return profile
        }

        func generateRequest(for email: String) throws -> Data? {
            let queryString = profileFor(email: email)
            guard let queryData = queryString.data(using: .utf8) else {
                return nil
            }
            let encryptedRequest = try cipher.encrypt(data: queryData)
            return encryptedRequest
        }
    }

    func run() {
        let server = Server()
        func encrypt(data: Data) -> Data {
            let email = String(decoding: data, as: UTF8.self)
            let result = try! server.generateRequest(for: email)!
            return result
        }

        let blockSize = Analysis.detectBlockSize(inMethod: encrypt(data:))

        // This relies a bit on knowledge about the encrypt(data:)'s plaintext suffix. I don't
        // know how to accomplish this without that.
        //
        // Let's make it encode a message like this:
        //     email=0000000000 adminBBBBBBBBBBB 000&uid=10&role= userCCCCCCCCCCCC
        // Where
        //   - B is pkcs7 padding for the rest of that block
        //   - C is pcks7 padding provided by the encrypt(data:) method for the rest of our input
        //   - 0 is any byte that helps align the blocks in this specific way.
        
        let emailBlock = Data(repeating: 0x41, count: blockSize - "email=".count)
        let adminBlock = Padding.pkcs7("admin".data(using: .utf8)!, blockSize: blockSize)
        let remainingPadding = Data(repeating: 0x41, count: blockSize - "&uid=10&role=".count)
        
        let encryptedBlocks = encrypt(data: emailBlock + adminBlock + remainingPadding)
        let encryptedAdminBlock = encryptedBlocks[blockSize..<2*blockSize]
        
        // Now, we'll re-use our admin block to replace the final block in this encoded message
        //     email=cdownie+cr yptopalsD@gmail. com&uid=10&role= userCCCCCCCCCCCC
        // Then, replace the final block with our "admin" block from earlier to create
        //     email=cdownie+cr yptopalsD@gmail. com&uid=10&role= adminBBBBBBBBBBB
        
        var attackPayload = encrypt(data: "cdownie+cryptopalsD@gmail.com".data(using: .utf8)!)
        attackPayload[3*blockSize..<4*blockSize] = encryptedAdminBlock
        
        // See if our payload tricks the server.
        let profile = try! server.createProfile(encryptedRequest: attackPayload)
        complete(success: profile?.role == "admin")
    }
}
