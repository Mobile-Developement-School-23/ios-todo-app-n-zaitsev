//
//  TaskDetailsCellModel.swift
//

import Foundation
import FileCache

struct TaskDetailsCellModel: Hashable {
    let id: String
    let text: String
    let importance: TodoItem.Importance
    let deadline: Date?
    let done: Bool
    let creationDate: Date

    init(item: TaskListItemModel) {
        self.id = item.id
        self.text = item.text
        self.importance = item.importance
        self.deadline = item.deadline
        self.done = item.done
        self.creationDate = item.creationDate
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(text)
        hasher.combine(importance)
        hasher.combine(deadline)
        hasher.combine(done)
        hasher.combine(creationDate)
    }

    static func == (lhs: TaskDetailsCellModel, rhs: TaskDetailsCellModel) -> Bool {
        [lhs.id == rhs.id,
         lhs.text == rhs.text,
         lhs.importance == rhs.importance,
         lhs.deadline == rhs.deadline,
         lhs.done == rhs.done,
         lhs.creationDate == rhs.creationDate
        ].allSatisfy({ $0 == true })
    }
}
