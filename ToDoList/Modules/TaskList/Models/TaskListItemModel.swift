//
//  TaskListItemModel.swift
//

import Foundation

final class TaskListItemModel {
    let id: String
    var text: String
    var creationDate: Date
    var deadline: Date?
    var changeDate: Date
    var importance: TodoItem.Importance
    var done: Bool
    var color: String?
    var alpha: CGFloat

    init(item: TodoItem) {
        self.id = item.id
        self.text = item.text
        self.creationDate = item.creationDate
        self.deadline = item.deadline
        self.changeDate = item.changeDate
        self.importance = item.importance
        self.done = item.done
        self.color = item.color
        self.alpha = item.alpha
    }

    func toItem() -> TodoItem {
        TodoItem(
            id: id,
            text: text,
            creationDate: creationDate,
            deadline: deadline,
            changeDate: changeDate,
            importance: importance,
            done: done,
            color: color,
            alpha: alpha
        )
    }
}
