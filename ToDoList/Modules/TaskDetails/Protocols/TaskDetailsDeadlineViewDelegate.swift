//
//  TaskDetailsDeadlineViewDelegate.swift
//

import Foundation

protocol TaskDetailsDeadlineViewDelegate: NSObject {
    func deadlineDidChange(switchIsOn: Bool, newDeadline: Date?)
    func didTapSubtitle()
}
