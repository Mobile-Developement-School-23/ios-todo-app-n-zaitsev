//
//  TaskDetailsDetailsViewDelegate.swift
//

import UIKit

protocol TaskDetailsDetailsViewDelegate: AnyObject {
    func deadlineDidChange(switchIsOn: Bool, newDeadline: Date?)
    func importanceValueDidChange(segment: Int)
    func colorDidChange(newColor: UIColor?)
}
