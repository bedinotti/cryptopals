//
//  DataDisplay.swift
//  CryptoTools
//
//  Created by Chris Downie on 4/25/21.
//

import Foundation

/// This namspace has a collection of functions for creating more easy-to-read displays of byte arrays.
/// Foundation provides implementations for these methods, so we're using our own namespace to be sure we're using our own implementation
enum DataDisplay {
    
    /// Convert a string of 2-digit hexidecimal numbers into a Data object
    /// - Parameter hexString: The hex string to convert
    /// - Returns: Those bytes as a Data object
    static func data(forHexString hexString: String) -> Data? {
        precondition(hexString.count % 2 == 0)
        return Data()
    }
    
    /// Convert a data object onto a string represention of 2-digit hex bytes
    /// - Parameter data: The data to convert
    /// - Returns: A hex string
    static func hexString(for data: Data) -> String {
        ""
    }
    
    
    /// Convert a base64-encoded string into its underlying Data representation
    /// - Parameter base64String: A valid base64-encoded string
    /// - Returns: Those bytes as a Data object
    static func data(forBase64String base64String: String) -> Data {
        Data()
    }
    
    /// Convert a data object into its base64-encoded String representation
    /// - Parameter data: The data to convert
    /// - Returns: A base64-encoded string
    static func base64String(for data: Data) -> String {
        ""
    }
}
