//
//  TodoItem+CSVParsing.swift
//

import Foundation

extension TodoItem {

    private static let csvSeparator = ";"

    static var csvHeader: String {
        var array = [String]()
        array.append(Keys.id.rawValue)
        array.append(Keys.text.rawValue)
        array.append(Keys.creationDate.rawValue)
        array.append(Keys.deadline.rawValue)
        array.append(Keys.changeDate.rawValue)
        array.append(Keys.importance.rawValue)
        array.append(Keys.done.rawValue)
        return array.joined(separator: Self.csvSeparator) + "\n"
    }

    var csv: String {
        var array = [String]()
        array.append(id)
        array.append(text)
        array.append(String(creationDate.timeIntervalSince1970))
        if let deadline = deadline {
            array.append(String(deadline.timeIntervalSince1970))
        } else {
            array.append("")
        }
        if let changeDate = changeDate {
            array.append(String(changeDate.timeIntervalSince1970))
        } else {
            array.append("")
        }
        if importance != .ordinary {
            array.append(importance.rawValue)
        } else {
            array.append("")
        }
        array.append(String(done))
        return array.joined(separator: Self.csvSeparator)
    }

    static func parse(csv: String) -> TodoItem? {
        var data = csv.components(separatedBy: Self.csvSeparator)
        let creationDateIndex = data.count - Keys.done.intValue - 1 + Keys.creationDate.intValue
        guard
            data.count > Keys.done.intValue,
            !data[Keys.id.intValue].isEmpty,
            let creationDate = Double(data[creationDateIndex])
        else {
            return nil
        }
        let text = data[Keys.text.intValue..<creationDateIndex].joined(separator: TodoItem.csvSeparator)
        data.removeSubrange(Keys.text.intValue..<creationDateIndex)
        data.insert(text, at: Keys.text.intValue)
        var deadline: Date?
        if let deadlineDouble = Double(data[Keys.deadline.intValue]) {
            deadline = Date(timeIntervalSince1970: deadlineDouble)
        }
        var changeDate: Date?
        if let changeDateDouble = Double(data[Keys.changeDate.intValue]) {
            changeDate = Date(timeIntervalSince1970: changeDateDouble)
        }
        return TodoItem(
                        id: data[Keys.id.intValue],
                        text: text,
                        creationDate: Date(timeIntervalSince1970: creationDate),
                        deadline: deadline,
                        changeDate: changeDate,
                        importance: Importance(rawValue: data[Keys.importance.intValue]) ?? .ordinary,
                        done: Bool(data[Keys.done.intValue]) ?? false
                        )
    }
}
