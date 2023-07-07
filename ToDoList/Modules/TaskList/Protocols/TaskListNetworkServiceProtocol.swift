//
//  TaskListNetworkServiceProtocol.swift
//

import Foundation

// swiftlint:disable line_length
protocol TaskListNetworkServiceProtocol: SingleTaskNetworkActionProtocol {
    func getTaskList(completion: @escaping (Result<TaskListResponse, Error>) -> Void)
    func updateTaskList(_ list: [TodoItem], revision: Int32, completion: @escaping (Result<TaskListResponse, Error>) -> Void)
}
// swiftlint:enable line_length
