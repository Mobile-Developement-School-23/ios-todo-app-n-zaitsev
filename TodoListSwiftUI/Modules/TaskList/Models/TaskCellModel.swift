//
//  TaskCellModel.swift
//

import Foundation
import Combine

final class TaskCellModel: ObservableObject {
    let id: String
    let text: String
    let importance: TodoItem.Importance
    let deadline: Date?
    @Published var done: Bool
    let creationDate: Date
    let color: String?
    let alpha: CGFloat

    init(item: TodoItem) {
        self.id = item.id
        self.text = item.text
        self.importance = item.importance
        self.deadline = item.deadline
        self.done = item.done
        self.creationDate = item.creationDate
        self.color = item.color
        self.alpha = item.alpha
    }
}
