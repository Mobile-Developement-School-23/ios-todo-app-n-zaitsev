//
//  TaskListNetworkServiceProtocol.swift
//

import Foundation

protocol TaskListNetworkServiceProtocol: AnyObject {
    func getTaskList(completion: @escaping (Result<TaskListResponse, Error>) -> Void)
}
