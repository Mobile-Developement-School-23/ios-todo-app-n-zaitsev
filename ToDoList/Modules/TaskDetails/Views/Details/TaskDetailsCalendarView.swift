//
//  TaskDetailsCalendarView.swift
//

import UIKit

final class TaskDetailsCalendarView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: TaskDetailsCalendarViewDelegate?

    // MARK: -private
    private lazy var calendar: UICalendarView = {
        let calendar = UICalendarView()
        calendar.locale = .init(identifier: "ru")
        calendar.calendar.firstWeekday = 2
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = dateSelection
        return calendar
    }()

    private func setupView() {
        addSubview(calendar)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            calendar.bottomAnchor.constraint(equalTo: bottomAnchor),
            calendar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            calendar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}

extension TaskDetailsCalendarView: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        delegate?.changeDeadlineFromCalendar(deadline: dateComponents?.date)
    }

    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
}
