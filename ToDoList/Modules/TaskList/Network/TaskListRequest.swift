//
//  TaskListRequest.swift
//

import Foundation

struct TaskListRequest: DataRequest {

    private let apiKey: String = "anisophyllous"

    var url: String = "https://beta.mrdekk.ru/todobackend/list"

    var headers: [String: String] = ["Authorization": "Bearer anisophyllous" ]
    var queryItems: [String: String] = [:]
    var method: HTTPMethod
    var body: Encodable?

    func decode(_ data: Data) throws -> TaskListResponse {
        let decoder = JSONDecoder()
        let response = try decoder.decode(TaskListResponse.self, from: data)
        return response
    }
}
