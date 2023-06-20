//
//  DateFormatter+LocalizableDate.swift
//

import Foundation

extension DateFormatter {
    static let ddMMMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru")
        return formatter
    }()
}
