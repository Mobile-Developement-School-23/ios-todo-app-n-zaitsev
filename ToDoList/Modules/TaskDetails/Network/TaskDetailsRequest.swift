//
//  TaskDetailsRequest.swift
//

import Foundation

struct TaskDetailsRequest: DataRequest {

    private let apiKey: String = "anisophyllous"

    var url: String = "https://beta.mrdekk.ru/todobackend" + "/list"

    var headers: [String: String] = ["Authorization": "Bearer anisophyllous" ]
    var queryItems: [String: String] = [:]
    var body: Encodable?
    var method: HTTPMethod

    func decode(_ data: Data) throws -> TaskDetailsResponse {
        let decoder = JSONDecoder()
        let response = try decoder.decode(TaskDetailsResponse.self, from: data)
        return response
    }
}
