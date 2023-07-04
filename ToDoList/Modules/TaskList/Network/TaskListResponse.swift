//
//  TaskListResponce.swift
//

import Foundation

struct TaskListResponce: Codable {
    let status: String
    let list: [TodoItem]
    let revision: Int32
}
