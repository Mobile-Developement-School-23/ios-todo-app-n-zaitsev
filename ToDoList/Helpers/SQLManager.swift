//
//  SQLManager.swift
//

import Foundation
import SQLite

class SQLManager {

    private(set) var todoItems: [String: TodoItem] = [:]

    @discardableResult
    func add(item: TodoItem) -> TodoItem? {
        todoItems.updateValue(item, forKey: item.id)
    }

    func remove(forKey key: String) {
        todoItems.removeValue(forKey: key)
    }

    init(file: String) {
        do {
            database = try Connection(try path(to: file))
            createTable()
        } catch let error {
            print(error)
        }
    }

    func save() {
        guard let database else {
            return
        }

        do {
            try database.run(tasks.delete())

            for item in todoItems {
                let insert = try tasks.insert(item.value)
                try database.run(insert)
            }
        } catch {
            print(error)
        }
    }

    func load() {
        guard let database else {
            return
        }

        do {
            for task in try database.prepare(tasks) {
                add(item: TodoItem(id: task[id],
                                   text: task[text],
                                   creationDate: task[creationDate],
                                   deadline: task[deadline],
                                   changeDate: task[changeDate],
                                   importance: TodoItem.Importance(rawValue: task[importance]) ?? .basic,
                                   done: task[done],
                                   color: task[color],
                                   lastUpdatedBy: task[lastUpdatedBy]))
            }
        } catch {
            print(error)
        }
    }

    func insert(item: TodoItem) {
        guard let database else {
            return
        }

        add(item: item)

        do {
            let insert = try tasks.insert(item)
            try database.run(insert)
        } catch {
            print(error)
        }
    }

    func update(item: TodoItem) {
        guard let database else {
            return
        }

        add(item: item)

        do {
            let row = tasks.filter(self.id == item.id)
            try database.run(row.update(item))
        } catch {
            print(error)
        }
    }

    func delete(with id: String) {
        guard let database else {
            return
        }

        remove(forKey: id)

        do {
            let item = tasks.filter(self.id == id)
            try database.run(item.delete())
        } catch {
            print(error)
        }
    }

    private let tasks = Table("tasks")

    private let id = Expression<String>(TodoItem.CodingKeys.id.rawValue)
    private let text = Expression<String>(TodoItem.CodingKeys.text.rawValue)
    private let creationDate = Expression<Date>(TodoItem.CodingKeys.creationDate.rawValue)
    private let deadline = Expression<Date?>(TodoItem.CodingKeys.deadline.rawValue)
    private let changeDate = Expression<Date>(TodoItem.CodingKeys.changeDate.rawValue)
    private let importance = Expression<String>(TodoItem.CodingKeys.importance.rawValue)
    private let done = Expression<Bool>(TodoItem.CodingKeys.done.rawValue)
    private let color = Expression<String?>(TodoItem.CodingKeys.color.rawValue)
    private let lastUpdatedBy = Expression<String>(TodoItem.CodingKeys.lastUpdatedBy.rawValue)

    private var database: Connection?

    private func createTable() {
        guard let database else {
            return
        }
        do {
            try database.run( tasks.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(text)
                table.column(creationDate)
                table.column(deadline)
                table.column(changeDate)
                table.column(importance)
                table.column(done)
                table.column(color)
                table.column(lastUpdatedBy)
            })
        } catch {
            print(error)
        }
    }

    private func path(to file: String) throws -> String {
        // swiftlint:disable:next line_length
        try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appending(path: "\(file).sqlite3").absoluteString
    }
}
