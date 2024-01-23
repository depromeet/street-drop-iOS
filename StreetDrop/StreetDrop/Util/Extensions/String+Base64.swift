//
//  String+Base64.swift
//  StreetDrop
//
//  Created by thoonk on 2024/01/11.
//

import Foundation

extension String {
    func fromBase64SafeURL() -> String? {
        var base64 = self
            .replacingOccurrences(of: "_", with: "/")
            .replacingOccurrences(of: "-", with: "+")
        
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        
        if let decodedData = Data(base64Encoded: base64) {
            if let decodedString = String(data: decodedData, encoding: .utf8) {
                return decodedString
            } else {
                print("Base64 디코딩 실패")
            }
        } else {
            print("유효하지 않은 Base64")
        }
        
        return nil
    }
    
    func toBase64SafeURL() -> String {
        let base = self.data(using: .utf8)!
        return base.base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
    }
}
