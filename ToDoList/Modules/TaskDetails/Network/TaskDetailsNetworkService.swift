//
//  TaskDetailsNetworkService.swift
//

import Foundation

final class TaskDetailsNetworkService: TaskDetailsNetworkServiceProtocol {

    let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func addItem(_ item: TodoItem, revision: Int32, completion: @escaping (Result<TodoItem, Error>) -> Void) {
        var request = TaskDetailsRequest(method: .post)
        request.body = TaskDetailsRequestBody(element: item)
        request.headers.updateValue("\(revision)", forKey: "X-Last-Known-Revision")
        networkService.produceRequest(request, completion: completion)
    }

    func getItem(with id: String, completion: @escaping (Result<TodoItem, Error>) -> Void) {
        var request = TaskDetailsRequest(method: .get)
        request.url += "/\(id)"
        networkService.produceRequest(request, completion: completion)
    }

    func changeItem(_ item: TodoItem, revision: Int32, completion: @escaping (Result<TodoItem, Error>) -> Void) {
        var request = TaskDetailsRequest(method: .put)
        request.url += "/\(item.id)"
        request.body = TaskDetailsRequestBody(element: item)
        request.headers.updateValue("\(revision)", forKey: "X-Last-Known-Revision")
        networkService.produceRequest(request, completion: completion)
    }
}
