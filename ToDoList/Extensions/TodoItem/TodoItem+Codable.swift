//
//  TodoItem+Codable.swift
//

import Foundation

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

        var intValue: Int {
            switch self {
            case .id:
                return 0
            case .text:
                return 1
            case .creationDate:
                return 2
            case .deadline:
                return 3
            case .changeDate:
                return 4
            case .importance:
                return 5
            case .done:
                return 6
            case .color:
                return 7
            case .lastUpdatedBy:
                return 8
            }
        }
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
        try? container.encode(id, forKey: .id)
        try? container.encode(text, forKey: .text)
        try? container.encode(Int64(creationDate.timeIntervalSince1970), forKey: .creationDate)
        if let deadline {
            try? container.encode(Int64(deadline.timeIntervalSince1970), forKey: .deadline)
        }
        try? container.encode(Int64(changeDate.timeIntervalSince1970), forKey: .changeDate)
        try? container.encode(importance.rawValue, forKey: .importance)
        try? container.encode(done, forKey: .done)
        if let color {
            try? container.encode(color, forKey: .color)
        }
        try? container.encode(lastUpdatedBy, forKey: .lastUpdatedBy)
    }
}
