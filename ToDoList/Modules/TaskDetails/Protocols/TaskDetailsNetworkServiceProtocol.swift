//
//  TaskDetailsNetworkServiceProtocol.swift
//

import Foundation

protocol TaskDetailsNetworkServiceProtocol: AnyObject {
    func addItem(_ item: TodoItem, revision: Int32, completion: @escaping (Result<TodoItem, Error>) -> Void)
    func getItem(with id: String, completion: @escaping (Result<TodoItem, Error>) -> Void)
    func changeItem(_ item: TodoItem, revision: Int32, completion: @escaping (Result<TodoItem, Error>) -> Void)
}
