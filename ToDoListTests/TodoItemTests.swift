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
}
