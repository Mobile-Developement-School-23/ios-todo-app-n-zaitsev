//
//  TaskDetailsViewProtocol.swift
//

import Foundation

protocol TaskDetailsViewProtocol: NSObject {
    func textViewDidChange(text: String)
    func deleteButtonDidTap()
    func deadlineDidChange(switchIsOn: Bool, newDeadline: Date?)
    func importanceValueDidChange(segment: Int)
}
