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
        data[Keys.importance.rawValue] = deadline?.timeIntervalSince1970
        data[Keys.changeDate.rawValue] = changeDate?.timeIntervalSince1970
        if importance != .ordinary {
            data[Keys.importance.rawValue] = importance.rawValue
        }
        data[Keys.done.rawValue] = done
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        return jsonData as Any
    }

    static func parse(json: Any) -> TodoItem? {
        switch json {
        case let json as Data:
            return parse(from: json)
        case let json as String:
            guard let data = json.data(using: .utf8) else {
                return nil
            }
            return parse(from: data)
        case let json as [String: Any]:
            return parse(from: json)
        default:
            return nil
        }
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

    private static func parse(from dict: [String: Any]) ->  TodoItem {
        let deadline = dict[Keys.deadline.rawValue] as? TimeInterval
        let changeDate = dict[Keys.changeDate.rawValue] as? TimeInterval
        return TodoItem(
                        id: dict[Keys.id.rawValue] as? String,
                        text: dict[Keys.text.rawValue] as? String ?? "",
                        creationDate: Date(timeIntervalSince1970: dict[Keys.creationDate.rawValue] as? TimeInterval ?? TimeInterval()),
                        deadline: deadline != nil ? Date(timeIntervalSince1970: deadline!) : nil,
                        changeDate: changeDate != nil ? Date(timeIntervalSince1970: changeDate!) : nil,
                        importance: dict[Keys.importance.rawValue] as? Importance ?? .ordinary,
                        done: dict[Keys.done.rawValue] as? Bool ?? false
                        )
    }

    private static func parse(from data: Data) -> TodoItem? {
        do {
            if let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return parse(from: dict)
            }
            return nil
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
}
