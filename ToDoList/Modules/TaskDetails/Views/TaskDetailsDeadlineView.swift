//
//  TaskDetailsDeadlineView.swift
//

import UIKit

class TaskDetailsDeadlineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var contentView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        return stack
    }()

    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = L10n.TaskDetails.Deadline.title
        label.tintColor = Assets.Colors.Label.primary.color
        return label
    }()

    private lazy var deadlineSwitch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        return sw
    }()

    private func setupView() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])

        contentView.addArrangedSubview(title)
        contentView.addArrangedSubview(deadlineSwitch)
        deadlineSwitch.translatesAutoresizingMaskIntoConstraints = false
    }
}
