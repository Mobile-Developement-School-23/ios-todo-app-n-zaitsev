//
//  TaskDetailsViewModel.swift
//

import SwiftUI

struct  TaskDetailsViewModel {
    let item: TodoItem
    @State var text: String
    @State var importance: TodoItem.Importance
    @State var deadline: Date?
    @State var supposedDeadline: Date

    var modelDidChange: Bool {
        ![item.text == text,
          item.importance == importance,
          item.deadline == deadline,
         ].allSatisfy({ $0 == true})
    }

    init(item: TodoItem) {
        self.item = item
        self._text = .init(initialValue: item.text)
        self._importance = .init(initialValue: item.importance)
        self._deadline = .init(initialValue: item.deadline)
        self._supposedDeadline = .init(initialValue: item.deadline ?? item.creationDate.dayAfter ?? Date())
    }

    func getNewItem() -> TodoItem {
        TodoItem(
            id: item.id,
            text: text,
            creationDate: item.creationDate,
            deadline: deadline,
            changeDate: Date(),
            importance: importance,
            done: item.done
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
