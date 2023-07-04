//
//  TaskDetailsDetailsView.swift
//

import UIKit

final class TaskDetailsDetailsView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Assets.Colors.Back.backSecondary.color
        layer.cornerRadius = 16
        axis = .vertical
        calendarSeparator.isHidden = true
        calendar.isHidden = true
        colorPickerSettingsSeparator.isHidden = true
        colorPickerSettingsView.isHidden = true
        setupView()
        deadlineView.delegate = self
        colorPicker.delegate = self
        colorPickerSettingsView.delegate = self
        calendar.delegate = self
        importanceView.onValueChange = { [weak self] segment in
            self?.delegate?.importanceValueDidChange(segment: segment)
        }
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: TaskDetailsDetailsViewDelegate?

    func setup(color: UIColor?, importance: TodoItem.Importance, deadline: Date?) {
        importanceView.setup(importance: importance)
        deadlineView.setup(with: deadline)
        colorPicker.setup(color: color)
        colorPickerSettingsView.setup(color: color, alpha: color?.alpha)
    }

    func update(deadline: Date?) {
        deadlineView.update(deadline: deadline)
        if deadline == nil {
            hideCalendar()
        }
    }

    // MARK: - private

    private lazy var importanceView = TaskDetailsImportanceView()
    private lazy var deadlineSeparator = TaskDetailsSeparator()
    private lazy var deadlineView = TaskDetailsDeadlineView()
    private lazy var calendarSeparator = TaskDetailsSeparator()
    private lazy var calendar = TaskDetailsCalendarView()
    private lazy var colorPickerViewSeparator = TaskDetailsSeparator()
    private lazy var colorPicker = TaskDetailsColorPicker()
    private lazy var colorPickerSettingsSeparator = TaskDetailsSeparator()
    private lazy var colorPickerSettingsView = ColorPickerSettingsView()

    private func setupView() {
        clipsToBounds = true
        addArrangedSubview(importanceView)
        addArrangedSubview(deadlineSeparator)
        addArrangedSubview(deadlineView)
        addArrangedSubview(calendarSeparator)
        addArrangedSubview(calendar)
        addArrangedSubview(colorPickerViewSeparator)
        addArrangedSubview(colorPicker)
        addArrangedSubview(colorPickerSettingsSeparator)
        addArrangedSubview(colorPickerSettingsView)
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

extension TaskDetailsDetailsView: TaskDetailsDeadlineViewDelegate {
    func deadlineDidChange(switchIsOn: Bool, newDeadline: Date?) {
        delegate?.deadlineDidChange(switchIsOn: switchIsOn, newDeadline: newDeadline)
    }

    func didTapSubtitle() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.calendarSeparator.isHidden.toggle()
            self?.calendar.isHidden.toggle()
        }
    }
}

extension TaskDetailsDetailsView: TaskDetailsColorPickerDelegate {
    func switchDidChange(value: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.colorPickerSettingsView.isHidden = !value
            self?.colorPickerSettingsSeparator.isHidden = !value
        }
    }
}

extension TaskDetailsDetailsView: ColorPickerViewDelegate {
    func colorDidChange(newColor: UIColor?) {
        delegate?.colorDidChange(newColor: newColor)
        colorPicker.setup(color: newColor)
        colorPickerSettingsView.setup(color: newColor)
    }
}

extension TaskDetailsDetailsView: ColorPickerSettingsViewDelegate {
    func sliderDidChange(color: UIColor?) {
        delegate?.colorDidChange(newColor: color)
        colorPicker.setup(color: color)
        colorPickerSettingsView.setup(color: color)
    }

    func colorDidChange(color: UIColor?) {
        delegate?.colorDidChange(newColor: color)
        colorPicker.setup(color: color)
        colorPickerSettingsView.setup(color: color)
    }
}

extension TaskDetailsDetailsView: TaskDetailsCalendarViewDelegate {
    func changeDeadlineFromCalendar(deadline: Date?) {
        delegate?.deadlineDidChange(switchIsOn: true, newDeadline: deadline)
    }
}
