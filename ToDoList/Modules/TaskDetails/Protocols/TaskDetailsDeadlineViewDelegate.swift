//
//  TaskDetailsDeadlineViewDelegate.swift
//

import Foundation

protocol TaskDetailsDeadlineViewDelegate: AnyObject {
    func deadlineDidChange(switchIsOn: Bool, newDeadline: Date?)
    func didTapSubtitle()
}
