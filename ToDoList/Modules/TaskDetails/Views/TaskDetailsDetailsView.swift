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
    
    var colorDidChange: ((UIColor) -> ())? {
        didSet {
            colorPicker.colorDidChange = colorDidChange
        }
    }

    func setup(color: UIColor, importance: TodoItem.Importance, deadline: Date?) {
        importanceView.setup(importance: importance)
        deadlineView.setup(with: deadline)
        colorPicker.setup(color: color)
    }
    
    func update(deadline: Date?) {
        deadlineView.update(deadline: deadline)
        if deadline == nil {
            hideCalendar()
        }
    }

    // MARK: -private
    
    private lazy var importanceView = TaskDetailsImportanceView()
    private lazy var deadlineSeparator = TaskDetailsSeparator()
    private lazy var deadlineView = TaskDetailsDeadlineView()
    private lazy var calendarSeparator = TaskDetailsSeparator()
    private lazy var calendar = TaskDetailsCalendarView()
    private lazy var colorPickerSeparator = TaskDetailsSeparator()
    private lazy var colorPicker = TaskDetailsColorPicker()

    private func setupView() {
        addArrangedSubview(importanceView)
        
        addArrangedSubview(deadlineSeparator)
        
        addArrangedSubview(deadlineView)
        
        addArrangedSubview(calendarSeparator)
        
        addArrangedSubview(calendar)

        addArrangedSubview(colorPickerSeparator)

        addArrangedSubview(colorPicker)
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
