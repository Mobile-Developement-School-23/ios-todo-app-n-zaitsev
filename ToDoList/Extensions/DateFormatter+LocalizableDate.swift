//
//  DateFormatter+LocalizableDate.swift
//

import Foundation

extension DateFormatter {
    static let dMMMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru")
        return formatter
    }()
}
