//
//  TaskDetailsNetworkService.swift
//

import Foundation

// swiftlint:disable line_length
final class TaskDetailsNetworkService: TaskDetailsNetworkServiceProtocol {

    let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func addItem(_ item: TodoItem, revision: Int32, completion: @escaping (Result<TaskDetailsResponse, Error>) -> Void) {
        var request = TaskDetailsRequest(method: .post)
        request.body = TaskDetailsRequestBody(element: item)
        request.headers.updateValue("\(revision)", forKey: "X-Last-Known-Revision")
        networkService.produceRequest(request, completion: completion)
    }

    func getItem(with id: String, completion: @escaping (Result<TaskDetailsResponse, Error>) -> Void) {
        var request = TaskDetailsRequest(method: .get)
        request.url += "/\(id)"
        networkService.produceRequest(request, completion: completion)
    }

    func changeItem(_ item: TodoItem, revision: Int32, completion: @escaping (Result<TaskDetailsResponse, Error>) -> Void) {
        var request = TaskDetailsRequest(method: .put)
        request.url += "/\(item.id)"
        request.body = TaskDetailsRequestBody(element: item)
        request.headers.updateValue("\(revision)", forKey: "X-Last-Known-Revision")
        networkService.produceRequest(request, completion: completion)
    }

    func deleteItem(with id: String, revision: Int32, completion: @escaping (Result<TaskDetailsResponse, Error>) -> Void) {
        var request = TaskDetailsRequest(method: .delete)
        request.url += "/\(id)"
        request.headers.updateValue("\(revision)", forKey: "X-Last-Known-Revision")
        networkService.produceRequest(request, completion: completion)
    }
}
// swiftlint:enable line_length
