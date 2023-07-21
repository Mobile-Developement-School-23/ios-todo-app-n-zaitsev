//
//  TodoItem.swift
//

import UIKit

struct TodoItem {
    let id: String
    let text: String
    let creationDate: Date
    let deadline: Date?
    let changeDate: Date
    let importance: Importance
    let done: Bool
    let color: String?
    let alpha: CGFloat
    let lastUpdatedBy: String

    enum Importance: String, Codable, Identifiable, CaseIterable {
        var id: Importance { self }

        case low
        case basic
        case important
    }

    init(
        id: String = UUID().uuidString,
        text: String = "",
        creationDate: Date = Date(),
        deadline: Date? = nil,
        changeDate: Date = Date(),
        importance: Importance = .basic,
        done: Bool = false,
        color: String? = nil,
        alpha: CGFloat = 1,
        lastUpdatedBy: String = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    ) {
        self.id = id
        self.text = text
        self.creationDate = creationDate
        self.deadline = deadline
        self.changeDate = changeDate
        self.importance = importance
        self.done = done
        self.color = color
        self.alpha = alpha
        self.lastUpdatedBy = lastUpdatedBy
    }
}
