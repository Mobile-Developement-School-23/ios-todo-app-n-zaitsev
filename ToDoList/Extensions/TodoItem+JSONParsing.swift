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
        guard
            let json = json as? [String : Any],
            let id = json[Keys.id.rawValue] as? String,
            !id.isEmpty,
            let creationTimeInterval = json[Keys.creationDate.rawValue] as? TimeInterval
        else {
            return nil
        }
        let deadline = json[Keys.deadline.rawValue] as? TimeInterval
        let changeDate = json[Keys.changeDate.rawValue] as? TimeInterval
        let importance: String = json[Keys.importance.rawValue] as? Importance.RawValue ?? Importance.ordinary.rawValue
        return TodoItem(
                        id: id,
                        text: json[Keys.text.rawValue] as? String ?? "",
                        creationDate: Date(timeIntervalSince1970: creationTimeInterval),
                        deadline: deadline != nil ? Date(timeIntervalSince1970: deadline!) : nil,
                        changeDate: changeDate != nil ? Date(timeIntervalSince1970: changeDate!) : nil,
                        importance: Importance(rawValue: importance) ?? .ordinary,
                        done: json[Keys.done.rawValue] as? Bool ?? false
                        )
    }

    enum Keys: String {
        case id
        case text
        case creationDate = "creation_date"
        case deadline
        case changeDate = "change_date"
        case importance
        case done

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
            }
        }
    }
}
