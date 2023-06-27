//
//  TaskDetailsTableViewCell.swift
//

import UIKit

final class TaskDetailsTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: TaskDetailsCellModel) {
        radioButton.layer.borderColor = Assets.Colors.Support.separator.color.cgColor
        switch model.importance {
        case .important:
            importanceView.image = Assets.Assets.Icons.Priority.high.image
            importanceView.isHidden = false
        case .unimportant:
            importanceView.image = Assets.Assets.Icons.Priority.low.image
            importanceView.isHidden = false
        case .ordinary:
            importanceView.isHidden = true
        }
        text.text = model.text
        // TODO: стрелочку
        if let deadline = model.deadline {
            deadlineLabel.isHidden = false
            deadlineImage.isHidden = false
            deadlineLabel.text = DateFormatter.dMMMM.string(from: deadline)
        } else {
            deadlineLabel.isHidden = true
            deadlineImage.isHidden = true
        }
    }
    
    // MARK: -private
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()

    private lazy var text: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        return label
    }()
    private lazy var radioButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        return button
    }()

    private var importanceView = UIImageView()
    private lazy var deadlineImage: UIImageView = {
        let image = UIImageView()
        image.image = Assets.Assets.Icons.calendar.image
        return image
    }()
    
    private lazy var deadlinetStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()

    private lazy var deadlineLabel = UILabel()

    private lazy var chevronView: UIImageView = {
        let image = UIImageView()
        image.image = Assets.Assets.Icons.chevron.image
        return image
    }()
 
    private func setupCell() {
        contentView.isUserInteractionEnabled = true
        addSubview(radioButton)
        NSLayoutConstraint.activate([
            radioButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            radioButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            radioButton.heightAnchor.constraint(equalToConstant: 24),
            radioButton.widthAnchor.constraint(equalToConstant: 24)
        ])
        addSubview(chevronView)
        chevronView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chevronView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

        ])
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 12),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            contentStackView.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: -16)
        ])
        contentStackView.addArrangedSubview(importanceView)
        importanceView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        importanceView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        contentStackView.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(text)
        textStackView.addArrangedSubview(deadlinetStackView)
        deadlinetStackView.addArrangedSubview(deadlineImage)
        deadlineImage.heightAnchor.constraint(equalToConstant: 16).isActive = true
        deadlineImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
        deadlinetStackView.addArrangedSubview(deadlineLabel)
    }

    @objc
    private func tapButton() {
        print("button tapped")
    }
}
