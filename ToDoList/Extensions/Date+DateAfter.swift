//
//  Date+DateAfter.swift
//

import Foundation

extension Date {
    var dayAfter: Date? {
        Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
}
