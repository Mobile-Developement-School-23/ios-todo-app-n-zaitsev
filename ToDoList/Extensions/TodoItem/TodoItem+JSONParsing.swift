//
//  TodoItem+JSONParsing.swift
//

import Foundation

extension TodoItem {
    var json: Any {
        var data = [String: Any]()
        data[CodingKeys.id.rawValue] = id
        data[CodingKeys.text.rawValue] = text
        data[CodingKeys.creationDate.rawValue] = creationDate.timeIntervalSince1970
        data[CodingKeys.deadline.rawValue] = deadline?.timeIntervalSince1970
        data[CodingKeys.changeDate.rawValue] = changeDate.timeIntervalSince1970
        if importance != .basic {
            data[CodingKeys.importance.rawValue] = importance.rawValue
        }
        data[CodingKeys.done.rawValue] = done
        data[CodingKeys.color.rawValue] = color
        data[CodingKeys.lastUpdatedBy.rawValue] = lastUpdatedBy
        return data
    }

    static func parse(json: Any) -> TodoItem? {
        guard
            let json = json as? [String: Any],
            let id = json[CodingKeys.id.rawValue] as? String,
            !id.isEmpty,
            let creationTimeInterval = json[CodingKeys.creationDate.rawValue] as? TimeInterval
        else {
            return nil
        }
        var deadline: Date?
        if let deadlineTimeInterval = json[CodingKeys.deadline.rawValue] as? TimeInterval {
            deadline = Date(timeIntervalSince1970: deadlineTimeInterval)
        }
        var changeDate: Date = Date()
        if let changeDateTimeInterval = json[CodingKeys.changeDate.rawValue] as? TimeInterval {
            changeDate = Date(timeIntervalSince1970: changeDateTimeInterval)
        }
        var importance: Importance = .basic
        if let importanceString = json[CodingKeys.importance.rawValue] as? String,
           let importanceTmp = Importance(rawValue: importanceString) {
            importance = importanceTmp
        }
        let color: String? = json[CodingKeys.color.rawValue] as? String
        let lastUpdatedBy = json[CodingKeys.lastUpdatedBy.rawValue] as? String ?? UUID().uuidString
        return TodoItem(
                        id: id,
                        text: json[CodingKeys.text.rawValue] as? String ?? "",
                        creationDate: Date(timeIntervalSince1970: creationTimeInterval),
                        deadline: deadline,
                        changeDate: changeDate,
                        importance: importance,
                        done: json[CodingKeys.done.rawValue] as? Bool ?? false,
                        color: color,
                        lastUpdatedBy: lastUpdatedBy)
    }
}
