//
//  TodoItemTests.swift
//

import XCTest
@testable import ToDoList

final class TodoItemTests: XCTestCase {

    private func loadJSON(from file: String) -> Any? {
        guard
            let url =  Bundle.main.url(forResource: file, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data)
        else { return nil }
        return json
    }

    private func loadCSV(from file: String) -> [String] {
        guard
            let url = Bundle.main.url(forResource: file, withExtension: "csv"),
            var csv = try? String(contentsOf: url).components(separatedBy: "\n"),
            !csv.isEmpty
        else { return [] }
        _ = csv.removeFirst()
        return csv
    }

    func test_TodoItem_id_isValidUUID() {
        let item = TodoItem(
                            id: nil,
                            text: UUID().uuidString,
                            creationDate: Date(),
                            deadline: nil, changeDate: nil,
                            importance: .ordinary,
                            done: Bool.random()
                    )
        XCTAssertNotNil(UUID(uuidString: item.id))
    }

    func test_TodoItem_done_shouldBeInjectedValue_stress() {
        for _ in 0..<10 {
            let done = Bool.random()
            let item = TodoItem(
                                id: nil,
                                text: "",
                                creationDate: Date(),
                                deadline: nil,
                                changeDate: nil,
                                importance: .ordinary,
                                done: done
                                )
            XCTAssertEqual(item.done, done)
        }
    }

    func test_TodoItem_dates_shouldBeInjectedValue_stress() {
        for _ in 0..<10 {
            let creationDate = Date() + TimeInterval.random(in: 0..<100)
            var deadline: Date?
            if Bool.random() {
                deadline = Date() + TimeInterval.random(in: 0..<100)
            }
            var changeDate: Date?
            if Bool.random() {
                changeDate = Date() + TimeInterval.random(in: 0..<100)
            }
            let item = TodoItem(
                                id: UUID().uuidString,
                                text: UUID().uuidString,
                                creationDate: creationDate,
                                deadline: deadline,
                                changeDate: changeDate,
                                importance: .ordinary,
                                done: Bool.random()
                        )

            XCTAssertEqual(item.creationDate, creationDate)
            XCTAssertEqual(item.deadline, deadline)
            XCTAssertEqual(item.changeDate, changeDate)
        }
    }

    func test_TodoItem_importance_shouldBeInjectedValue_stress() {
        for _ in 0..<10 {
            let array: [TodoItem.Importance] = [.unimportant, .ordinary, .important]
            let importance = array.randomElement()!
            let item = TodoItem(
                                id: UUID().uuidString,
                                text: UUID().uuidString,
                                creationDate: Date(),
                                deadline: nil,
                                changeDate: nil,
                                importance: importance,
                                done: Bool.random()
                        )
            XCTAssertEqual(item.importance, importance)
        }
    }

    func test_TodoItem_idAndText_shouldBeInjectedValues_stress() {
        for _ in 0..<10 {
            let id = UUID().uuidString
            let text = UUID().uuidString
            let item = TodoItem(
                                id: id,
                                text: text,
                                creationDate: Date(),
                                deadline: nil,
                                changeDate: nil,
                                importance: .ordinary,
                                done: Bool.random()
                        )
            XCTAssertEqual(item.id, id)
            XCTAssertEqual(item.text, text)
        }
    }

    func test_TodoItem_json_shouldMakeJSON() {
        let item = TodoItem(
                            id: UUID().uuidString,
                            text: UUID().uuidString,
                            creationDate: Date(),
                            deadline: nil,
                            changeDate: nil,
                            importance: .ordinary,
                            done: Bool.random()
                    )
        let json = item.json
        XCTAssertNotNil(json)
        XCTAssertNotNil(json as? [String: Any])
        XCTAssertNoThrow(try JSONSerialization.data(withJSONObject: json))
    }

    func test_TodoItem_json_shouldNotContainOrdinaryImportance_stress() {
        for _ in 0..<10 {
            let array: [TodoItem.Importance] = [.unimportant, .ordinary, .important]
            let importance = array.randomElement()!
            let item = TodoItem(
                                id: UUID().uuidString,
                                text: UUID().uuidString,
                                creationDate: Date(),
                                deadline: nil,
                                changeDate: nil,
                                importance: importance,
                                done: Bool.random()
                        )
            let json = item.json as? [String: Any]
            guard let contains = json?.contains(where: { $0.key == TodoItem.Keys.importance.rawValue}) else {
                XCTAssertNotNil(json)
                return
            }
            XCTAssertEqual(contains, importance != .ordinary)
        }
    }

    func test_TodoItem_json_shouldNotContainNilDates_stress() {
        for _ in 0..<10 {
            var deadline: Date?
            if Bool.random() {
                deadline = Date() + TimeInterval.random(in: 0..<100)
            }
            var changeDate: Date?
            if Bool.random() {
                changeDate = Date() + TimeInterval.random(in: 0..<100)
            }
            let item = TodoItem(
                                id: UUID().uuidString,
                                text: UUID().uuidString,
                                creationDate: Date(),
                                deadline: deadline,
                                changeDate: changeDate,
                                importance: .ordinary,
                                done: Bool.random()
                        )
            guard let json = item.json as? [String: Any] else {
                XCTAssertNotNil(item.json as? [String: Any])
                return
            }
            let containsDeadline = json.contains(where: { $0.key == TodoItem.Keys.deadline.rawValue })
            XCTAssertEqual(containsDeadline, deadline != nil)
            let containsChangeDate = json.contains(where: { $0.key == TodoItem.Keys.changeDate.rawValue })
            XCTAssertEqual(containsChangeDate, changeDate != nil)
        }
    }

    func test_TodoItem_parse_json_shouldNotBeNilWithFullJSON() {
        guard let json = loadJSON(from: "todoitem_full") else {
            return
        }
        guard let item = TodoItem.parse(json: json) else {
            XCTAssertNotNil(TodoItem.parse(json: json))
            return
        }
        XCTAssertTrue(!item.id.isEmpty)
        XCTAssertNotNil(item.deadline)
        XCTAssertNotNil(item.changeDate)
        XCTAssertNotEqual(item.importance, TodoItem.Importance.ordinary)
    }

    func test_TodoItem_parse_json_shouldBeNilWithEmptyJSON() {
        guard let json = loadJSON(from: "todoitem_empty") else {
            return
        }
        let item = TodoItem.parse(json: json)
        XCTAssertNil(item)
    }

    func test_TodoItem_parse_json_shouldBeNilWithBrokenId() {
        guard let json = loadJSON(from: "todoitem_broken_id") else {
            return
        }
        let item = TodoItem.parse(json: json)
        XCTAssertNil(item)
    }

    func test_TodoItem_parse_json_shouldBeNilWithBrokenCreationDate() {
        guard let json = loadJSON(from: "todoitem_broken_creationDate") else {
            return
        }
        let item = TodoItem.parse(json: json)
        XCTAssertNil(item)
    }

    func test_TodoItem_parse_json_importanceShouldBeOrdinary() {
        guard let json = loadJSON(from: "todoitem_ordinary") else {
            return
        }
        guard let item = TodoItem.parse(json: json) else {
            XCTAssertNotNil(TodoItem.parse(json: json))
            return
        }
        XCTAssertEqual(item.importance, TodoItem.Importance.ordinary)
    }

    func test_TodoItem_parse_json_optionalDatesShouldBeNil() {
        guard let json = loadJSON(from: "todoitem_without_optional_dates") else {
            return
        }
        guard let item = TodoItem.parse(json: json) else {
            XCTAssertNotNil(TodoItem.parse(json: json))
            return
        }
        XCTAssertNil(item.deadline)
        XCTAssertNil(item.changeDate)
    }

    func test_TodoItem_parse_json_doneShouldBeFalseWithBrokenDone() {
        guard let json = loadJSON(from: "todoitem_broken_done") else {
            return
        }
        guard let item = TodoItem.parse(json: json) else {
            XCTAssertNotNil(TodoItem.parse(json: json))
            return
        }
        XCTAssertFalse(item.done)
    }

    func test_TodoItem_csv_shouldMakeCSV() {
        let item = TodoItem(
                            id: "1",
                            text: "text",
                            creationDate: Date(timeIntervalSince1970: 1686664070),
                            deadline: Date(timeIntervalSince1970: 1686664072),
                            changeDate: Date(timeIntervalSince1970: 1686664071),
                            importance: .important,
                            done: true
                    )
        let string = "1;text;1686664070.0;1686664072.0;1686664071.0;important;true"
        let csv = item.csv
        XCTAssertEqual(string, csv)
    }

    func test_TodoItem_csv_shouldNotContainOrdinaryImportance() {
        let item = TodoItem(
                            id: "1",
                            text: "text",
                            creationDate: Date(timeIntervalSince1970: 1686664070),
                            deadline: Date(timeIntervalSince1970: 1686664072),
                            changeDate: Date(timeIntervalSince1970: 1686664071),
                            importance: .ordinary,
                            done: true
                    )
        let string = "1;text;1686664070.0;1686664072.0;1686664071.0;;true"
        let csv = item.csv
        XCTAssertEqual(string, csv)
    }

    func test_TodoItem_csv_shouldNotContainNilDates() {
        let item = TodoItem(
                            id: "1",
                            text: "text",
                            creationDate: Date(timeIntervalSince1970: 1686664070),
                            deadline: nil,
                            changeDate: nil,
                            importance: .ordinary,
                            done: true
                            )
        let string = "1;text;1686664070.0;;;;true"
        let csv = item.csv
        XCTAssertEqual(string, csv)
    }

    func test_TodoItem_parse_csv_shouldNotBeNilWithFullCSV() {
        var csv = loadCSV(from: "todoitem_full")
        guard !csv.isEmpty else {
            return
        }
        csv.removeAll(where: { $0.isEmpty })
        guard let first = csv.first else {
            XCTAssertFalse(csv.isEmpty)
            return
        }
        guard let item = TodoItem.parse(csv: first) else {
            XCTAssertNotNil(TodoItem.parse(csv: first))
            return
        }
        XCTAssertFalse(item.id.isEmpty)
        XCTAssertNotNil(item.deadline)
        XCTAssertNotNil(item.changeDate)
        XCTAssertNotEqual(item.importance, TodoItem.Importance.ordinary)

    }

    func test_TodoItem_parse_csv_shouldBeNilWithEmptyJSON() {
        var csv = loadCSV(from: "todoitem_empty")
        guard let first = csv.first else {
            XCTAssertFalse(csv.isEmpty)
            return
        }
        let item = TodoItem.parse(csv: first)
        XCTAssertNil(item)
    }

    func test_TodoItem_parse_csv_shouldBeNilWithWrongSeparator() {
        var csv = loadCSV(from: "todoitem_wrong_separator")
        csv.removeAll(where: { $0.isEmpty })
        guard let first = csv.first else {
            XCTAssertFalse(csv.isEmpty)
            return
        }
        let item = TodoItem.parse(csv: first)
        XCTAssertNil(item)
    }

    func test_TodoItem_parse_csv_shouldBeNilWithBrokenId() {
        var csv = loadCSV(from: "todoitem_broken_id")
        csv.removeAll(where: { $0.isEmpty })
        
        guard let first = csv.first else {
            XCTAssertFalse(csv.isEmpty)
            return
        }
        let item = TodoItem.parse(csv: first)
        XCTAssertNil(item)
    }

    func test_TodoItem_parse_csv_importanceShouldBeNilWithBrokenCreationDate() {
        var csv = loadCSV(from: "todoitem_broken_creationDate")
        csv.removeAll(where: { $0.isEmpty })
        guard let first = csv.first else {
            XCTAssertFalse(csv.isEmpty)
            return
        }
        let item = TodoItem.parse(csv: first)
        XCTAssertNil(item)
    }

    func test_TodoItem_parse_csv_shouldBeOrdinary() {
        var csv = loadCSV(from: "todoitem_ordinary")
        csv.removeAll(where: { $0.isEmpty })
        guard let first = csv.first else {
            XCTAssertFalse(csv.isEmpty)
            return
        }
        guard let item = TodoItem.parse(csv: first) else {
            XCTAssertNotNil(TodoItem.parse(csv: first))
            return
        }
        XCTAssertEqual(item.importance, TodoItem.Importance.ordinary)

    }

    func test_TodoItem_parse_csv_optionalDatesShouldBeNil() {
        var csv = loadCSV(from: "todoitem_without_optional_dates")
        csv.removeAll(where: { $0.isEmpty })
        guard let first = csv.first else {
            XCTAssertFalse(csv.isEmpty)
            return
        }
        guard let item = TodoItem.parse(csv: first) else {
            XCTAssertNotNil(TodoItem.parse(csv: first))
            return
        }
        XCTAssertNil(item.deadline)
        XCTAssertNil(item.changeDate)
    }

    func test_TodoItem_parse_csv_doneShouldBeFalseWithBrokenDone() {
        var csv = loadCSV(from: "todoitem_without_optional_dates")
        csv.removeAll(where: { $0.isEmpty })
        guard let first = csv.first else {
            XCTAssertFalse(csv.isEmpty)
            return
        }
        guard let item = TodoItem.parse(csv: first) else {
            XCTAssertNotNil(TodoItem.parse(csv: first))
            return
        }
        XCTAssertFalse(item.done)
    }
}
