//
//  TodoItemTests.swift
//

import XCTest
@testable import ToDoList

final class TodoItemTests: XCTestCase {

    func test_TodoItem_id_isValidUUID() {
        let item = TodoItem(id: nil, text: UUID().uuidString, creationDate: Date(), deadline: nil, changeDate: nil, importance: .ordinary, done: Bool.random())
        
        XCTAssertNotNil(UUID(uuidString: item.id))
    }

    func test_TodoItem_done_shouldBeInjectedValue_stress() {
        for _ in 0..<10 {
            let done = Bool.random()
            
            let item = TodoItem(id: nil, text: "", creationDate: Date(), deadline: nil, changeDate: nil, importance: .ordinary, done: done)

            XCTAssertEqual(item.done, done)
        }
    }

    func test_TodoItem_dates_shouldBeInjectedValue_stress() {
        for _ in 0..<10 {
            let creationDate = Date() + TimeInterval.random(in: 0..<100)
            var deadline: Date? = nil
            if Bool.random() {
                deadline = Date() + TimeInterval.random(in: 0..<100)
            }
            var changeDate: Date? = nil
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
        XCTAssertNotNil(json as? [String : Any])
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
            let json = item.json as? [String : Any]
            let contains = json!.contains(where: { $0.key == TodoItem.Keys.importance.rawValue})
            XCTAssertEqual(contains, importance != .ordinary)
        }
    }

    func test_TodoItem_json_shouldNotContainNilDates_stress() {
        for _ in 0..<10 {
            var deadline: Date? = nil
            if Bool.random() {
                deadline = Date() + TimeInterval.random(in: 0..<100)
            }
            var changeDate: Date? = nil
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
            let json = item.json as? [String: Any]
            let containsDeadline = json!.contains(where: { $0.key == TodoItem.Keys.deadline.rawValue })
            let containsChangeDate = json!.contains(where: { $0.key == TodoItem.Keys.changeDate.rawValue })
            XCTAssertEqual(containsDeadline, deadline != nil)
            XCTAssertEqual(containsChangeDate, changeDate != nil)
        }
    }

    func test_TodoItem_parse_json_shouldNotBeNilWithFullJSON() {
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "todoitem_full", withExtension: "json")!)
        let json = try! JSONSerialization.jsonObject(with: data)
        let item = TodoItem.parse(json: json)
        
        XCTAssertNotNil(item)
        XCTAssertTrue(!item!.id.isEmpty)
        XCTAssertNotNil(item?.deadline)
        XCTAssertNotNil(item?.changeDate)
        XCTAssertNotEqual(item!.importance, TodoItem.Importance.ordinary)
    }

    func test_TodoItem_parse_json_shouldBeNilWithEmptyJSON() {
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "todoitem_empty", withExtension: "json")!)
        let json = try! JSONSerialization.jsonObject(with: data)
        let item = TodoItem.parse(json: json)
        XCTAssertNil(item)
    }

    func test_TodoItem_parse_json_shouldBeNilWithBrokenId() {
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "todoitem_broken_id", withExtension: "json")!)
        let json = try! JSONSerialization.jsonObject(with: data)
        let item = TodoItem.parse(json: json)
        XCTAssertNil(item)
    }

    func test_TodoItem_parse_json_shouldBeNilWithBrokenCreationDate() {
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "todoitem_broken_creationDate", withExtension: "json")!)
        let json = try! JSONSerialization.jsonObject(with: data)
        let item = TodoItem.parse(json: json)
        XCTAssertNil(item)
    }

    func test_TodoItem_parse_json_importanceShouldBeOrdinary() {
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "todoitem_ordinary", withExtension: "json")!)
        let json = try! JSONSerialization.jsonObject(with: data)
        let item = TodoItem.parse(json: json)
        XCTAssertNotNil(item)
        XCTAssertEqual(item!.importance, TodoItem.Importance.ordinary)
    }

    func test_TodoItem_parse_json_optionalDatesShouldBeNil() {
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "todoitem_without_optional_dates", withExtension: "json")!)
        let json = try! JSONSerialization.jsonObject(with: data)
        let item = TodoItem.parse(json: json)
        XCTAssertNotNil(item)
        XCTAssertNil(item!.deadline)
        XCTAssertNil(item!.changeDate)
    }

    func test_TodoItem_parse_json_doneShouldBeFalseWithBrokenDone() {
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "todoitem_broken_done", withExtension: "json")!)
        let json = try! JSONSerialization.jsonObject(with: data)
        let item = TodoItem.parse(json: json)
        XCTAssertNotNil(item)
        XCTAssertFalse(item!.done)
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
        print(csv)
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
        var csv = try! String(contentsOf: Bundle.main.url(forResource: "todoitem_full", withExtension: "csv")!).components(separatedBy: "\n")
        _ = csv.removeFirst()
        XCTAssertTrue(!csv.isEmpty)
        let item = TodoItem.parse(csv: csv.first!)
        
        XCTAssertNotNil(item)
        XCTAssertFalse(item!.id.isEmpty)
        XCTAssertNotNil(item?.deadline)
        XCTAssertNotNil(item?.changeDate)
        XCTAssertNotEqual(item!.importance, TodoItem.Importance.ordinary)
    }

    func test_TodoItem_parse_csv_shouldBeNilWithEmptyJSON() {
        var csv = try! String(contentsOf: Bundle.main.url(forResource: "todoitem_empty", withExtension: "csv")!).components(separatedBy: "\n")
        _ = csv.removeFirst()
        XCTAssertFalse(csv.isEmpty)
        let item = TodoItem.parse(csv: csv.first!)
        XCTAssertNil(item)
    }

    func test_TodoItem_parse_csv_shouldBeNilWithWrongSeparator() {
        var csv = try! String(contentsOf: Bundle.main.url(forResource: "todoitem_wrong_separator", withExtension: "csv")!).components(separatedBy: "\n")
        _ = csv.removeFirst()
        XCTAssertFalse(csv.isEmpty)
        let item = TodoItem.parse(csv: csv.first!)
        XCTAssertNil(item)
    }

    func test_TodoItem_parse_csv_shouldBeNilWithBrokenId() {
        var csv = try! String(contentsOf: Bundle.main.url(forResource: "todoitem_broken_id", withExtension: "csv")!).components(separatedBy: "\n")
        _ = csv.removeFirst()
        XCTAssertFalse(csv.isEmpty)
        let item = TodoItem.parse(csv: csv.first!)
        XCTAssertNil(item)
    }

    func test_TodoItem_parse_csv_importanceShouldBeNilWithBrokenCreationDate() {
        var csv = try! String(contentsOf: Bundle.main.url(forResource: "todoitem_broken_creationDate", withExtension: "csv")!).components(separatedBy: "\n")
        _ = csv.removeFirst()
        XCTAssertFalse(csv.isEmpty)
        let item = TodoItem.parse(csv: csv.first!)
        XCTAssertNil(item)
    }
    
    func test_TodoItem_parse_csv_shouldBeOrdinary() {
        var csv = try! String(contentsOf: Bundle.main.url(forResource: "todoitem_ordinary", withExtension: "csv")!).components(separatedBy: "\n")
        _ = csv.removeFirst()
        XCTAssertFalse(csv.isEmpty)
        let item = TodoItem.parse(csv: csv.first!)
        XCTAssertNotNil(item)
        XCTAssertEqual(item?.importance, TodoItem.Importance.ordinary)
    }
    
    func test_TodoItem_parse_csv_optionalDatesShouldBeNil() {
        var csv = try! String(contentsOf: Bundle.main.url(forResource: "todoitem_without_optional_dates", withExtension: "csv")!).components(separatedBy: "\n")
        _ = csv.removeFirst()
        XCTAssertFalse(csv.isEmpty)
        let item = TodoItem.parse(csv: csv.first!)
        XCTAssertNotNil(item)
        XCTAssertNil(item?.deadline)
        XCTAssertNil(item?.changeDate)
    }

    func test_TodoItem_parse_csv_doneShouldBeFalseWithBrokenDone() {
        var csv = try! String(contentsOf: Bundle.main.url(forResource: "todoitem_broken_done", withExtension: "csv")!).components(separatedBy: "\n")
        _ = csv.removeFirst()
        XCTAssertFalse(csv.isEmpty)
        let item = TodoItem.parse(csv: csv.first!)
        XCTAssertNotNil(item)
        XCTAssertFalse(item!.done)
    }
}
