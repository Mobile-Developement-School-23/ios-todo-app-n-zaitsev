//
//  TaskListViewDelegate.swift
//

import Foundation

protocol TaskListViewDelegate: AnyObject {
    func onAddButtonTap()
    func onRadionButtonTap(item: TaskDetailsCellModel, expanded: Bool) -> Int
}
