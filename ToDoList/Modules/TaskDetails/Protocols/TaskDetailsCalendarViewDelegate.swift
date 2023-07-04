//
//  TaskDetailsCalendarViewDelegate.swift
//

import Foundation

protocol TaskDetailsCalendarViewDelegate: AnyObject {
    func changeDeadlineFromCalendar(deadline: Date?)
}
