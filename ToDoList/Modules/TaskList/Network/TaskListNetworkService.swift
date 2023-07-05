//
//  TaskListNetworkService.swift
//

import Foundation

final class TaskListNetworkService: TaskListNetworkServiceProtocol {

    let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getTaskList(completion: @escaping (Result<TaskListResponse, Error>) -> Void) {
        let request = TaskListRequest(method: .get)
        networkService.produceRequest(request, completion: completion)
    }
}
