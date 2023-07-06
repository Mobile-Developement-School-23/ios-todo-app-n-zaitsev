//
//  TaskListNetworkServiceProtocol.swift
//

import Foundation

protocol TaskListNetworkServiceProtocol: SingleTaskNetworkActionProtocol {
    func getTaskList(completion: @escaping (Result<TaskListResponse, Error>) -> Void)
}
