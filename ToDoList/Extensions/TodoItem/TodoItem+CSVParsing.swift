//
//  TodoItem+CSVParsing.swift
//

import Foundation

extension TodoItem {

    private static let csvSeparator = ";"

    static var csvHeader: String {
        var array = [String]()
        array.append(CodingKeys.id.rawValue)
        array.append(CodingKeys.text.rawValue)
        array.append(CodingKeys.creationDate.rawValue)
        array.append(CodingKeys.deadline.rawValue)
        array.append(CodingKeys.changeDate.rawValue)
        array.append(CodingKeys.importance.rawValue)
        array.append(CodingKeys.done.rawValue)
        array.append(CodingKeys.color.rawValue)
        array.append(CodingKeys.lastUpdatedBy.rawValue)
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
        array.append(String(changeDate.timeIntervalSince1970))
        if importance != .basic {
            array.append(importance.rawValue)
        } else {
            array.append("")
        }
        array.append(String(done))
        if let color {
            array.append(color)
        } else {
            array.append("")
        }
        array.append(lastUpdatedBy)
        return array.joined(separator: Self.csvSeparator)
    }

    static func parse(csv: String) -> TodoItem? {
        var data = csv.components(separatedBy: Self.csvSeparator)
        let creationDateIndex = data.count - CodingKeys.lastUpdatedBy.intValue - 1 + CodingKeys.creationDate.intValue
        guard
            data.count > CodingKeys.lastUpdatedBy.intValue!,
            !data[CodingKeys.id.intValue!].isEmpty,
            let creationDate = Double(data[creationDateIndex])
        else {
            return nil
        }
        let text = data[CodingKeys.text.intValue..<creationDateIndex].joined(separator: TodoItem.csvSeparator)
        data.removeSubrange(CodingKeys.text.intValue..<creationDateIndex)
        data.insert(text, at: CodingKeys.text.intValue)
        var deadline: Date?
        if let deadlineDouble = Double(data[CodingKeys.deadline.intValue]) {
            deadline = Date(timeIntervalSince1970: deadlineDouble)
        }
        var changeDate: Date = Date()
        if let changeDateDouble = Double(data[CodingKeys.changeDate.intValue]) {
            changeDate = Date(timeIntervalSince1970: changeDateDouble)
        }
        return TodoItem(
                        id: data[CodingKeys.id.intValue],
                        text: text,
                        creationDate: Date(timeIntervalSince1970: creationDate),
                        deadline: deadline,
                        changeDate: changeDate,
                        importance: Importance(rawValue: data[CodingKeys.importance.intValue]) ?? .basic,
                        done: Bool(data[CodingKeys.done.intValue]) ?? false
                        )
    }
}
