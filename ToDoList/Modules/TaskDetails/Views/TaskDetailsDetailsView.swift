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
            self?.deadlineDidChange?(true, deadline)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var deadlineDidChange: ((Bool, Date?) -> ())? {
        didSet {
            deadlineView.changeDeadline = deadlineDidChange
        }
    }

    var importanceValueDidChange: ((Int) -> ())? {
        didSet {
            importanceView.onValueChange = importanceValueDidChange
        }
    }
    
    func setup(importance: TodoItem.Importance, deadline: Date?) {
        importanceView.setup(importance: importance)
        deadlineView.setup(with: deadline)
        hideCalendar()
    }
    
    func update(deadline: Date?) {
        deadlineView.update(deadline: deadline)
        if deadline == nil {
            hideCalendar()
        }
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
    
    private func hideCalendar() {
        if calendar.isHidden == false {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.calendarSeparator.isHidden = true
                self?.calendar.isHidden = true
            }
        }
    }
}
