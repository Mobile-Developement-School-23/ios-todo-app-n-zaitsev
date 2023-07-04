//
//  TaskDetailsDeadlineView.swift
//

import UIKit

final class TaskDetailsDeadlineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: TaskDetailsDeadlineViewDelegate?

    func setup(with deadline: Date?) {
        deadlineSwitch.setOn(deadline != nil, animated: true)
        subtitle.isHidden = deadline == nil
        if let deadline {
            subtitle.text = DateFormatter.dMMMMyyyy.string(from: deadline)
        }
    }

    func update(deadline: Date?) {
        UIView.animate(withDuration: 0.05) {
            self.subtitle.isHidden = deadline == nil
            if let deadline {
                self.subtitle.text = DateFormatter.dMMMMyyyy.string(from: deadline)
            }
        }
    }

    // MARK: - private
    private lazy var contentView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()

    private lazy var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = L10n.TaskDetails.Deadline.title
        label.tintColor = Assets.Colors.Label.labelPrimary.color
        label.font = Font.body.font
        return label
    }()

    private lazy var subtitle: UILabel = {
        let label = UILabel()
        label.textColor = Assets.Colors.Color.blue.color
        label.font = Font.footnote.font
        let subtitelTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSubtitle))
        label.addGestureRecognizer(subtitelTapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var deadlineSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = false
        uiSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        return uiSwitch
    }()

    private func setupView() {
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])

        contentView.addArrangedSubview(titleStack)
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        titleStack.addArrangedSubview(title)
        titleStack.addArrangedSubview(subtitle)
        contentView.addArrangedSubview(deadlineSwitch)
    }

    @objc
    private func switchChanged(mySwitch: UISwitch) {
        delegate?.deadlineDidChange(switchIsOn: mySwitch.isOn, newDeadline: nil)
    }

    @objc
    private func didTapSubtitle(_ sender: UITapGestureRecognizer) {
        delegate?.didTapSubtitle()
    }
}
