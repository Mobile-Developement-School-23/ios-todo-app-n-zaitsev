//
//  TaskDetailsModel.swift
//

import UIKit

class TaskDetailsModel {
    let item: TodoItem
    var text: String
    var importance: TodoItem.Importance
    var deadline: Date?
    let initialColor: UIColor?
    var color: UIColor?

    private var supposedDeadline: Date?
    
    var modelDidChange: Bool {
        ![item.text == text,
          item.importance == importance,
          item.deadline == deadline,
          color == initialColor,
         ].allSatisfy({ $0 == true})
    }

    init(item: TodoItem) {
        self.item = item
        self.text = item.text
        self.importance = item.importance
        self.deadline = item.deadline
        self.supposedDeadline = item.deadline ?? item.creationDate.dayAfter
        self.color = item.color != nil ? UIColor(hex: item.color, alpha: item.alpha) : Assets.Colors.Label.labelPrimary.color
        self.initialColor = UIColor(hex: item.color, alpha: item.alpha)
    }

    func getNewItem() -> TodoItem {
        TodoItem(
            id: item.id,
            text: text,
            creationDate: item.creationDate,
            deadline: deadline,
            changeDate: Date(),
            importance: importance,
            done: item.done,
            color: color?.hexa,
            alpha: color?.cgColor.alpha ?? 1.0
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
