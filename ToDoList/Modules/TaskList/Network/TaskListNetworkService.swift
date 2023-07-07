//
//  TaskListNetworkService.swift
//

import Foundation

// swiftlint:disable line_length
final class TaskListNetworkService: TaskListNetworkServiceProtocol {

    let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getTaskList(completion: @escaping (Result<TaskListResponse, Error>) -> Void) {
        let request = TaskListRequest(method: .get)
        Task {
            await networkService.produceRequest(request, completion: completion)
        }
    }

    func addItem(_ item: TodoItem, revision: Int32, completion: @escaping (Result<TaskDetailsResponse, Error>) -> Void) {
        Task {
            var request = TaskDetailsRequest(method: .post)
            request.body = TaskDetailsRequestBody(element: item)
            request.headers.updateValue("\(revision)", forKey: "X-Last-Known-Revision")
            await networkService.produceRequest(request, completion: completion)
        }
    }

    func changeItem(_ item: TodoItem, revision: Int32, completion: @escaping (Result<TaskDetailsResponse, Error>) -> Void) {
        Task {
            var request = TaskDetailsRequest(method: .put)
            request.url += "/\(item.id)"
            request.body = TaskDetailsRequestBody(element: item)
            request.headers.updateValue("\(revision)", forKey: "X-Last-Known-Revision")
            await networkService.produceRequest(request, completion: completion)
        }
    }

    func deleteItem(with id: String, revision: Int32, completion: @escaping (Result<TaskDetailsResponse, Error>) -> Void) {
        Task {
            var request = TaskDetailsRequest(method: .delete)
            request.url += "/\(id)"
            request.headers.updateValue("\(revision)", forKey: "X-Last-Known-Revision")
            await networkService.produceRequest(request, completion: completion)
        }
    }

    func updateTaskList(_ list: [TodoItem], revision: Int32, completion: @escaping (Result<TaskListResponse, Error>) -> Void) {
        Task {
            var request = TaskListRequest(method: .patch)
            request.body = TaskListRequestBody(list: list)
            request.headers.updateValue("\(revision)", forKey: "X-Last-Known-Revision")

            await networkService.produceRequest(request, completion: completion)
        }
    }
}
// swiftlint:enable line_length
