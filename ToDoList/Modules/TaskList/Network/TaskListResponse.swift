//
//  TaskListResponse.swift
//

import Foundation

struct TaskListResponse: Codable {
    let status: String
    let list: [TodoItem]
    let revision: Int32
}
