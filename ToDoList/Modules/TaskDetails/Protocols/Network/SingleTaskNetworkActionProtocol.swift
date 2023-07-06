//
//  SingleTaskNetworkActionProtocol.swift
//

import Foundation

protocol SingleTaskNetworkActionProtocol: AnyObject {
    func addItem(_ item: TodoItem, revision: Int32, completion: @escaping (Result<TaskDetailsResponse, Error>) -> Void)
    func changeItem(_ item: TodoItem, revision: Int32, completion: @escaping (Result<TaskDetailsResponse, Error>) -> Void)
    func deleteItem(with id: String, revision: Int32, completion: @escaping (Result<TaskDetailsResponse, Error>) -> Void)
}
