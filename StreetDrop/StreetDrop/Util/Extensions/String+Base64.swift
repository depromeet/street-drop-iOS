//
//  String+Base64.swift
//  StreetDrop
//
//  Created by thoonk on 2024/01/11.
//

import Foundation

extension String {
    func fromSafeBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        guard var url = String(data: data, encoding: .utf8)?
            .replacingOccurrences(of: "_", with: "/")
            .replacingOccurrences(of: "-", with: "+")
        else { return nil }
        
        if url.count % 4 != 0 {
            url.append(String(repeating: "=", count: 4 - url.count % 4))
        }
        
        return url
    }
    
    func toSafeBase64() -> String {
        let base = self.replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
        return Data(base.utf8).base64EncodedString()
    }
}
