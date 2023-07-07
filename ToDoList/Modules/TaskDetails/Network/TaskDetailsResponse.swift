//
//  TaskDetailsResponse.swift
//

import Foundation

struct TaskDetailsResponse: Codable {
    let status: String
    let element: TodoItem
    let revision: Int32
}
