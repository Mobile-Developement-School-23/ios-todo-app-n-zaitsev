//
//  TodoItem+JSONParsing.swift
//

import Foundation

extension TodoItem {
    var json: Any {
        var data = [String: Any]()
        data[Keys.id.rawValue] = id
        data[Keys.text.rawValue] = text
        data[Keys.creationDate.rawValue] = creationDate.timeIntervalSince1970
        data[Keys.deadline.rawValue] = deadline?.timeIntervalSince1970
        data[Keys.changeDate.rawValue] = changeDate?.timeIntervalSince1970
        if importance != .ordinary {
            data[Keys.importance.rawValue] = importance.rawValue
        }
        data[Keys.done.rawValue] = done
        return data
    }

    static func parse(json: Any) -> TodoItem? {
        if let json = json as? [String : Any] {
            let deadline = json[Keys.deadline.rawValue] as? TimeInterval
            let changeDate = json[Keys.changeDate.rawValue] as? TimeInterval
            let importance: String = json[Keys.importance.rawValue] as? Importance.RawValue ?? Importance.ordinary.rawValue
            return TodoItem(
                            id: json[Keys.id.rawValue] as? String,
                            text: json[Keys.text.rawValue] as? String ?? "",
                            creationDate: Date(timeIntervalSince1970: json[Keys.creationDate.rawValue] as? TimeInterval ?? TimeInterval()),
                            deadline: deadline != nil ? Date(timeIntervalSince1970: deadline!) : nil,
                            changeDate: changeDate != nil ? Date(timeIntervalSince1970: changeDate!) : nil,
                            importance: Importance(rawValue: importance) ?? .ordinary,
                            done: json[Keys.done.rawValue] as? Bool ?? false
                            )
        }
        return nil
    }

    enum Keys: String {
        case id
        case text
        case creationDate = "creation_date"
        case deadline
        case changeDate = "change_date"
        case importance
        case done
    }
}
