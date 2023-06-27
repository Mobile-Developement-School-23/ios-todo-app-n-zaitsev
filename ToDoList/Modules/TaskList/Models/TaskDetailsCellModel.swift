//
//  TaskDetailsCellModel.swift
//

import Foundation

struct TaskDetailsCellModel: Hashable {
    let id: String
    let text: String
    let importance: TodoItem.Importance
    let deadline: Date?
    let done: Bool

    init(item: TaskListItemModel) {
        self.id = item.id
        self.text = item.text
        self.importance = item.importance
        self.deadline = item.deadline
        self.done = item.done
    }
}
