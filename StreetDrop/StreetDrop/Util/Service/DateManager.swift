//
//  DateManager.swift
//  StreetDrop
//
//  Created by jihye kim on 16/06/2024.
//

import Foundation

protocol DateManager {
    func convertToformattedString(_ dateString: String) -> String?
}

final class DefaultDateManager: DateManager {
    func convertToformattedString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter.string(from: date)
    }
}
