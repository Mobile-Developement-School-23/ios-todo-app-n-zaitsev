//
//  DataManager.swift
//  ToDoList
//

import Foundation

protocol DataManager: AnyObject {
    var todoItems: [String: TodoItem] { get }
    func save()
    func load()
    func insert(item: TodoItem)
    func update(item: TodoItem)
    func delete(with id: String)
    @discardableResult func add(item: TodoItem) -> TodoItem?
    @discardableResult func remove(forKey key: String) -> TodoItem?
}
