//
//  String+ToDate.swift
//  StreetDrop
//
//  Created by thoonk on 9/30/24.
//

import Foundation

extension String {
    func toDate(
        format: String = "yyyy-MM-dd HH:mm:ss",
        timeZone: TimeZone? = TimeZone(identifier: "Asia/Seoul")
    ) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: self)
    }
}
