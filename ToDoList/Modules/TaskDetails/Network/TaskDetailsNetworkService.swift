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
        request.body.updateValue(Item(item: item), forKey: "element")
        request.headers.updateValue("\(revision)", forKey: "X-Last-Known-Revision")
        networkService.produceRequest(request, completion: completion)
    }
}

struct Item: Codable {
    let id: String
    let text: String
    let creationDate: Int64
    let deadline: Int64?
    let changeDate: Int64
    let importance: TodoItem.Importance
    let done: Bool
    let color: String?
    let lastUpdatedBy: String

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case creationDate = "created_at"
        case deadline
        case changeDate = "changed_at"
        case importance
        case done
        case color
        case lastUpdatedBy = "last_updated_by"
    }

    init(item: TodoItem) {
        self.id = item.id
        self.text = item.text
        self.creationDate = Int64(item.creationDate.timeIntervalSince1970)
        self.importance = item.importance
        self.done = item.done
        self.color = item.color
        self.lastUpdatedBy = item.lastUpdatedBy!
        if let deadline = item.deadline {
            self.deadline = Int64(deadline.timeIntervalSince1970)
        } else {
            self.deadline = nil
        }
        if let changeDate = item.changeDate {
            self.changeDate = Int64(changeDate.timeIntervalSince1970)
        } else {
            self.changeDate = creationDate
        }
    }
}
