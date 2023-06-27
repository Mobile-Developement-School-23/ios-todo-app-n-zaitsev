//
//  TaskListInfoTableViewCell.swift
//

import UIKit

final class TaskListInfoTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tapOnShowLabel: ((Bool) -> ())?

    func configure(with count: Int) {
        infoLabel.text = L10n.TaskList.InfoCell.Info.title(count)
    }

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.TaskList.InfoCell.Info.title(0)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var actionLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.TaskList.InfoCell.Action.title
        label.textColor = Assets.Colors.Color.blue.color
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnLabel)))
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

    private func setupCell() {
        backgroundColor = .clear
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
        ])
        stack.addArrangedSubview(infoLabel)
        stack.addArrangedSubview(actionLabel)
    }

    @objc
    private func tapOnLabel() {
        print("tap")
    }
}
