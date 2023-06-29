//
//  TaskListCreateNewItemCell.swift
//

import UIKit

class TaskListCreateNewItemCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Assets.Colors.Label.tertiary.color
        label.font = Font.body.font
        label.text = L10n.TaskList.CreateNew.title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func setupCell() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 56),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 52),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
