//
//  TaskListRequest.swift
//

import Foundation

struct TaskListRequest: DataRequest {

    private let apiKey: String = "anisophyllous"

    var url: String {
        let baseURL: String =  "https://beta.mrdekk.ru/todobackend"
        let path: String = "/list"
        return baseURL + path
    }

    var headers: [String: String] = ["Authorization": "Bearer anisophyllous" ]
    var queryItems: [String: String] = [:]
    var body: [String: Any] = [:]
    var method: HTTPMethod

    func decode(_ data: Data) throws -> [TodoItem] {
        let decoder = JSONDecoder()
        let response = try decoder.decode(TaskListResponce.self, from: data)
        return response.list
    }
}
