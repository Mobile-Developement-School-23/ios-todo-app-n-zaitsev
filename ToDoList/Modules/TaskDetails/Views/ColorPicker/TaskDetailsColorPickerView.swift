//
//  TaskDetailsColorPicker.swift
//

import UIKit

class TaskDetailsColorPicker: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: TaskDetailsColorPickerDelegate?

    func setup(color: UIColor?) {
        subtitle.text = color?.hexa
        subtitle.textColor = color
    }

    // MARK: -private

    private lazy var contentView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = L10n.TaskDetails.ColorPicker.title
        label.tintColor = Assets.Colors.Label.labelPrimary.color
        label.font = Font.body.font
        return label
    }()

    private lazy var subtitle: UILabel = {
        let label = UILabel()
        label.textColor = Assets.Colors.Color.blue.color
        label.font = Font.footnote.font
        return label
    }()

    private lazy var colorSwitch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        sw.addTarget(self, action: #selector(switchDidChangeValue), for: .valueChanged)
        return sw
    }()

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])

        contentView.addArrangedSubview(titleStack)
        titleStack.addArrangedSubview(title)
        titleStack.addArrangedSubview(subtitle)
        contentView.addArrangedSubview(colorSwitch)
    }

    @objc
    private func switchDidChangeValue(_ uiswitch: UISwitch) {
        delegate?.switchDidChange(value: uiswitch.isOn)
    }
}
