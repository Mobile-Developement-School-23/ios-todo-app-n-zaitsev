//
//  TodoItem.swift
//

import UIKit

struct TodoItem {
    let id: String
    let text: String
    let creationDate: Date
    let deadline: Date?
    let changeDate: Date?
    let importance: Importance
    let done: Bool
    let color: String?
    let alpha: CGFloat

    enum Importance: String {
        case unimportant
        case ordinary
        case important
    }

    init(
        id: String = UUID().uuidString,
        text: String = "",
        creationDate: Date = Date(),
        deadline: Date? = nil,
        changeDate: Date? = nil,
        importance: Importance = .ordinary,
        done: Bool = false,
        color: String? = nil,
        alpha: CGFloat = 1
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
    }
}
