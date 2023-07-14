//
//  TodoItem+CoreData.swift
//

import Foundation

extension TodoItem {
    static func parse(from cdItem: CoreDataTodoItem) -> TodoItem? {
        guard let id = cdItem.id, let createdAt = cdItem.created_at else {
            return nil
        }

        var importance: Importance = .basic
        if let importanceString = cdItem.importance,
           let importanceTmp = Importance(rawValue: importanceString) {
            importance = importanceTmp
        }
        return TodoItem(id: id,
                        text: cdItem.text ?? "",
                        creationDate: createdAt,
                        deadline: cdItem.deadline,
                        changeDate: cdItem.changed_at ?? createdAt,
                        importance: importance,
                        done: cdItem.done,
                        color: cdItem.color,
                        lastUpdatedBy: cdItem.last_updated_by ?? UUID().uuidString)
    }
}
