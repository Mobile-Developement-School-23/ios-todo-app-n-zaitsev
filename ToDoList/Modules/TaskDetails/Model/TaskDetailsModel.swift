//
//  TaskDetailsModel.swift
//

import UIKit

class TaskDetailsModel {
    let item: TodoItem
    var text: String
    var importance: TodoItem.Importance
    var deadline: Date?
    var color: UIColor

    private var supposedDeadline: Date?
    
    var modelDidChange: Bool {
        ![item.text == text, item.importance == importance, item.deadline == deadline, item.textColor == color].allSatisfy({ $0 == true})
    }

    init(item: TodoItem) {
        self.item = item
        self.text = item.text
        self.importance = item.importance
        self.deadline = item.deadline
        self.supposedDeadline = item.deadline ?? item.creationDate.dayAfter
        self.color = item.textColor
    }

    func getNewItem() -> TodoItem {
        TodoItem(
            id: item.id,
            text: text,
            creationDate: item.creationDate,
            deadline: deadline,
            changeDate: item.changeDate,
            importance: importance,
            done: item.done,
            color: color
        )
    }

    func changeDeadline(newDeadline: Date?, deadlineIsNeeded: Bool) {
        if deadlineIsNeeded {
            self.deadline = newDeadline ?? self.supposedDeadline
            if let newDeadline {
                self.supposedDeadline = newDeadline
            }
        } else {
            self.deadline = nil
        }
    }
}
