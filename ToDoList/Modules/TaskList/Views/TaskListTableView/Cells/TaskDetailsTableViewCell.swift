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

    var onRadioButtonTap: (() -> ())?
    var onDetails: ((Bool) -> ())?
    var onDelete: (() -> ())?


    func configure(with model: TaskDetailsCellModel) {
        configureRadioButton(with: model)
        configureImportanceView(with: model)
        configureText(with: model)
        configureDeadlineView(with: model)
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
        label.font = Font.body.font
        label.textColor = Assets.Colors.Label.labelPrimary.color
        return label
    }()

    private lazy var radioButton: TaskListCellRadioButton = {
        let button = TaskListCellRadioButton()
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        return button
    }()

    private var importanceView = UIImageView()

    private lazy var deadlineImage: UIImageView = {
        let image = UIImageView()
        image.image = Assets.Assets.Icons.calendar.image.withTintColor( Assets.Colors.Label.tertiary.color)
        return image
    }()
    
    private lazy var deadlinetStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()

    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = Font.subhead.font
        label.textColor = Assets.Colors.Label.tertiary.color
        return label
    }()

    private lazy var chevronView: UIImageView = {
        let image = UIImageView()
        image.image = Assets.Assets.Icons.chevron.image
        return image
    }()
 
    private func setupCell() {
        contentView.isUserInteractionEnabled = true
        heightAnchor.constraint(greaterThanOrEqualToConstant: 56).isActive = true
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
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
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
    
    private func configureDeadlineView(with model: TaskDetailsCellModel) {
        deadlineLabel.isHidden = model.deadline == nil
        deadlineImage.isHidden = model.deadline == nil
        if let deadline = model.deadline {
            deadlineLabel.text = DateFormatter.dMMMM.string(from: deadline)
        }
    }

    private func configureText(with model: TaskDetailsCellModel) {
        text.textColor = model.done ? Assets.Colors.Label.tertiary.color : Assets.Colors.Label.labelPrimary.color
        if model.done {
            let attributeString = NSMutableAttributedString(string: model.text)
            attributeString.addAttribute(.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            text.attributedText = attributeString
        } else {
            let attributeString = NSMutableAttributedString(string: model.text)
            attributeString.addAttribute(.strikethroughStyle, value: 0, range: NSRange(location: 0, length: attributeString.length))
            text.attributedText = attributeString
        }
    }

    private func configureImportanceView(with model: TaskDetailsCellModel) {
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
    }

    private func configureRadioButton(with model: TaskDetailsCellModel) {
        guard !model.done else {
            radioButton.setImage(Assets.Assets.Icons.radioButtonDone.image, for: .normal)
            return
        }
        guard model.importance != .important else {
            radioButton.setImage(Assets.Assets.Icons.radioButtonImportant.image, for: .normal)
            return
        }
        radioButton.setImage(
            Assets.Assets.Icons.radioButtonCommon.image.withTintColor(Assets.Colors.Support.separator.color),
            for: .normal)
    }

    @objc
    private func tapButton() {
        onRadioButtonTap?()
    }
}
