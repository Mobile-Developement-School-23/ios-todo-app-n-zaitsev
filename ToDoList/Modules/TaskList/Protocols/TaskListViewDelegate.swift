//
//  TaskListViewDelegate.swift
//

import Foundation

protocol TaskListViewDelegate: AnyObject {
    func onAddButtonTap()
    func onRadionButtonTap(id: String, expanded: Bool) -> Int
    func onDetails(id: String, state: TaskDetailsState, animated: Bool)
    func onDelete(id: String)
}
