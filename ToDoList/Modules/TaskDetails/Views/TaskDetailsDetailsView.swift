//
//  TaskDetailsDetailsView.swift
//

import UIKit

class TaskDetailsDetailsView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Assets.Colors.Back.secondary.color
        layer.cornerRadius = 16
        axis = .vertical
        calendarSeparator.isHidden = true
        calendar.isHidden = true
        setupView()
        deadlineView.expandCalendar = { [weak self] in
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.calendarSeparator.isHidden.toggle()
                self?.calendar.isHidden.toggle()
            }
        }
        calendar.changeDeadlineFromCalendar = { [weak self] deadline in
            self?.changeDeadline?(true, deadline)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var changeDeadline: ((Bool, Date?) -> ())? {
        didSet {
            deadlineView.changeDeadline = changeDeadline
        }
    }

    func setup(importance: TodoItem.Importance, deadline: Date?) {
        importanceView.set(importance: importance)
        deadlineView.setup(with: deadline)
    }

    func set(deadline: Date?) {
        deadlineView.set(deadline: deadline)
    }

    // MARK: -private

    private lazy var importanceView = TaskDetailsImportanceView()
    private lazy var separator = TaskDetailsSeparator()
    private lazy var deadlineView = TaskDetailsDeadlineView()
    private lazy var calendarSeparator = TaskDetailsSeparator()
    private var calendar = TaskDetailsCalendarView()

    private func setupView() {
        addArrangedSubview(importanceView)

        addArrangedSubview(separator)

        addArrangedSubview(deadlineView)

        addArrangedSubview(calendarSeparator)

        addArrangedSubview(calendar)
    }
    
}
