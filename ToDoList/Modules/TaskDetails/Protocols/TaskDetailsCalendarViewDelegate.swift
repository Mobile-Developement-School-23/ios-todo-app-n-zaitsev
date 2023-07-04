//
//  TaskDetailsCalendarViewDelegate.swift
//

import Foundation

protocol TaskDetailsCalendarViewDelegate: NSObject {
    func changeDeadlineFromCalendar(deadline: Date?)
}
