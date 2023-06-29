//
//  TaskDetailsViewDelegate.swift
//

import UIKit

protocol TaskDetailsViewDelegate: AnyObject {
    func textViewDidChange(text: String)
    func deleteButtonDidTap()
    func deadlineDidChange(switchIsOn: Bool, newDeadline: Date?)
    func importanceValueDidChange(segment: Int)
    func colorDidChange(newColor: UIColor?)
}
