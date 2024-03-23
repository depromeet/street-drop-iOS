//
//  String+Base64.swift
//  StreetDrop
//
//  Created by thoonk on 2024/01/11.
//

import Foundation

extension String {
    
    func base64UrlEncode() -> String? {
        let base = self.data(using: .utf8)!
        return base.base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: ".")
    }

    func base64UrlDecode() -> String? {
        let base64 = self
            .replacingOccurrences(of: "_", with: "/")
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: ".", with: "=")
        
        guard let decodedData = Data(base64Encoded: base64) else {
            print("Invalid Base64 string")
            return nil
        }

        guard let decodedString = String(data: decodedData, encoding: .utf8) else {
            print("Base64 decoding failed")
            return nil
        }

        return decodedString
    }
    
}
