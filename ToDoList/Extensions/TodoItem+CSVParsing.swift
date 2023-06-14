//
//  TodoItem+CSVParsing.swift
//

import Foundation

extension TodoItem {
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
        array.append(importance.rawValue)
        array.append(String(done))
        return array.joined(separator: ",")
    }

    static func getHeaderForCSV() -> String {
        var array = [String]()
        array.append(Keys.id.rawValue)
        array.append(Keys.text.rawValue)
        array.append(Keys.creationDate.rawValue)
        array.append(Keys.deadline.rawValue)
        array.append(Keys.changeDate.rawValue)
        array.append(Keys.importance.rawValue)
        array.append(Keys.done.rawValue)
        return array.joined(separator: ",") + "\n"
    }
}
