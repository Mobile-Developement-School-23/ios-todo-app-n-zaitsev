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
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var changeDeadline: ((Bool, Date?) -> ())? {
        didSet {
            deadlineView.changeDeadline = changeDeadline
        }
    }

    func set(importance: TodoItem.Importance, deadline: Date?) {
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

    private func setupView() {
        addArrangedSubview(importanceView)

        addArrangedSubview(separator)

        addArrangedSubview(deadlineView)
    }
    
}
