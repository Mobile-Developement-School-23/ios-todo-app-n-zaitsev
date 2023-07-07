//
//  TaskListNetworkServiceProtocol.swift
//

import Foundation

protocol TaskListNetworkServiceProtocol: SingleTaskNetworkActionProtocol {
    func getTaskList(completion: @escaping (Result<TaskListResponse, Error>) -> Void)
    func updateTaskList(_ list: [TodoItem], revision: Int32, completion: @escaping (Result<TaskListResponse, Error>) -> Void)
}
