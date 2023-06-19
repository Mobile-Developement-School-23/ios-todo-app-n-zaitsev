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
    


    // MARK: -private

    private lazy var importanceView = TaskDetailsImportanceView()
    private lazy var separator = TaskDetailsSeparator()
    private lazy var deadlineView = TaskDetailsDeadlineView()

    private func setupView() {
        addArrangedSubview(importanceView)
        importanceView.heightAnchor.constraint(equalToConstant: 56).isActive = true

        addArrangedSubview(separator)

        addArrangedSubview(deadlineView)
    }
    
}
