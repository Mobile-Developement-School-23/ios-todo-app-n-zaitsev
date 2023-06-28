//
//  TaskListSectionAndRows.swift
//

import Foundation

enum TaskListSection: Hashable {
    case main
}

enum TaskListRow: Hashable {
    case details(TaskDetailsCellModel)
    case create
}
