//
//  TaskListInfoView.swift
//

import UIKit

final class TaskListInfoView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tapOnShowLabel: ((Bool) -> ())?

    func configure(with count: Int, expanded: Bool) {
        actionLabel.isUserInteractionEnabled = count != 0
        actionLabel.textColor = count == 0 ? Assets.Colors.Label.tertiary.color : Assets.Colors.Color.blue.color
        infoLabel.text = L10n.TaskList.InfoCell.Info.title(count)
        self.expanded = expanded
    }

    private(set) var expanded = true {
        didSet {
            actionLabel.text = expanded ? L10n.TaskList.InfoCell.Action.Hide.title : L10n.TaskList.InfoCell.Action.Show.title
        }
    }

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.TaskList.InfoCell.Info.title(0)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var actionLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.TaskList.InfoCell.Action.Hide.title
        label.textColor = Assets.Colors.Color.blue.color
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnLabel)))
        label.isUserInteractionEnabled = true
        label.textAlignment = .right
        return label
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private func setupView() {
        contentView.isUserInteractionEnabled = true
        isUserInteractionEnabled = true
        backgroundConfiguration?.backgroundColor = .clear
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
        ])
        stack.addArrangedSubview(infoLabel)
        stack.addArrangedSubview(actionLabel)
    }

    @objc
    private func tapOnLabel() {
        tapOnShowLabel?(expanded)
    }
}
