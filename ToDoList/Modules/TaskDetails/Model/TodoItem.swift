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
    let lastUpdatedBy: String?

    enum Importance: String, Codable {
        case low
        case basic
        case important
    }

    init(
        id: String = UUID().uuidString,
        text: String = "",
        creationDate: Date = Date(),
        deadline: Date? = nil,
        changeDate: Date? = nil,
        importance: Importance = .basic,
        done: Bool = false,
        color: String? = nil,
        alpha: CGFloat = 1,
        lastUpdatedBy: String? = UIDevice.current.identifierForVendor?.uuidString
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

extension TodoItem: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case creationDate = "created_at"
        case deadline
        case changeDate = "changed_at"
        case importance
        case done
        case color
        case lastUpdatedBy = "last_updated_by"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let text = try container.decode(String.self, forKey: .text)
        let creationDateInt = try container.decode(Int64.self, forKey: .creationDate)
        let deadlineInt = try? container.decode(Int64?.self, forKey: .deadline)
        let changeDateInt = try container.decode(Int64.self, forKey: .changeDate)
        let importance = try container.decode(Importance.self, forKey: .importance)
        let done = try container.decode(Bool.self, forKey: .done)
        let color = try? container.decode(String?.self, forKey: .color)
        let lastUpdatedBy = try container.decode(String.self, forKey: .lastUpdatedBy)
        var deadline: Date?
        if let deadlineInt {
            deadline = Date(timeIntervalSince1970: TimeInterval(deadlineInt))
        }
        self.init(id: id,
                  text: text,
                  creationDate: Date(timeIntervalSince1970: TimeInterval(creationDateInt)),
                  deadline: deadline,
                  changeDate: Date(timeIntervalSince1970: TimeInterval(changeDateInt)),
                  importance: importance,
                  done: done,
                  color: color,
                  lastUpdatedBy: lastUpdatedBy)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(creationDate.timeIntervalSince1970, forKey: .creationDate)
        try container.encode(deadline?.timeIntervalSince1970, forKey: .deadline)
        try container.encode(changeDate?.timeIntervalSince1970, forKey: .changeDate)
        try container.encode(importance, forKey: .importance)
        try container.encode(done, forKey: .done)
        try container.encode(color, forKey: .color)
        try container.encode(lastUpdatedBy, forKey: .lastUpdatedBy)
    }
}
