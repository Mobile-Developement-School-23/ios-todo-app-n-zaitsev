//
//  TaskListRequestBody.swift
//

import Foundation

struct TaskListRequestBody: Codable {
    let list: [TodoItem]
}
