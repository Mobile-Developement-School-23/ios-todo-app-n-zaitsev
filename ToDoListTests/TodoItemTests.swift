//
//  TodoItemTests.swift
//

import XCTest
@testable import ToDoList

final class TodoItemTests: XCTestCase {

    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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

    func test_TodoItem_parse_shouldBeNilWithNotDict() {
        let itemFromArray = TodoItem.parse(json: [Any]())
        let itemFromString = TodoItem.parse(json: UUID().uuidString)
        let itemFromData = TodoItem.parse(json: Data())
        let itemFromSet = TodoItem.parse(json: Set<AnyHashable>())
        XCTAssertNil(itemFromArray)
        XCTAssertNil(itemFromString)
        XCTAssertNil(itemFromData)
        XCTAssertNil(itemFromSet)
    }

    func test_TodoItem_parse_shouldNotBeNilWithFullJSON() {
        let dataFromFullJSON = try! Data(contentsOf: Bundle.main.url(forResource: "todoitem_full", withExtension: "json")!)
        let fullJSON = try! JSONSerialization.jsonObject(with: dataFromFullJSON)
        let itemFromFullJSON = TodoItem.parse(json: fullJSON)
        
        XCTAssertNotNil(itemFromFullJSON)
        XCTAssertTrue(!itemFromFullJSON!.id.isEmpty)
        XCTAssertNotNil(itemFromFullJSON?.deadline)
        XCTAssertNotNil(itemFromFullJSON?.changeDate)
        XCTAssertTrue(itemFromFullJSON!.importance != TodoItem.Importance.ordinary)
    }

    func test_TodoItem_parse_shouldNotBeNilWithEmptyJSON() {
        let dataFromEmptyJSON = try! Data(contentsOf: Bundle.main.url(forResource: "todoitem_empty", withExtension: "json")!)
        let emptyJSON = try! JSONSerialization.jsonObject(with: dataFromEmptyJSON)
        let itemFromEmptyJSON = TodoItem.parse(json: emptyJSON)
        
        XCTAssertNotNil(itemFromEmptyJSON)
        XCTAssertNotNil(UUID(uuidString: itemFromEmptyJSON!.id))
        XCTAssertNil(itemFromEmptyJSON!.deadline)
        XCTAssertNil(itemFromEmptyJSON!.changeDate)
        XCTAssertFalse(itemFromEmptyJSON!.done)
        XCTAssertTrue(itemFromEmptyJSON!.importance == TodoItem.Importance.ordinary)
    }

}
