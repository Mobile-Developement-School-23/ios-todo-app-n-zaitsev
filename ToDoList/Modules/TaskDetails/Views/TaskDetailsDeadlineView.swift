//
//  TaskDetailsDeadlineView.swift
//

import UIKit

class TaskDetailsDeadlineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        deadlineSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        let subtitelTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSubtitle(_:)))
        subtitle.addGestureRecognizer(subtitelTapGesture)
        subtitle.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var changeDeadline: ((Bool, Date?) -> ())?
    var expandCalendar: (() -> ())?

    func setup(with deadline: Date?) {
        deadlineSwitch.setOn(deadline != nil, animated: true)
        subtitle.isHidden = deadline == nil
        if let deadline {
            subtitle.text = DateFormatter.dMMMMyyyy.string(from: deadline)
        }
    }

    func update(deadline: Date?) {
        UIView.animate(withDuration: 0.1) {
            self.subtitle.isHidden = deadline == nil
            if let deadline {
                self.subtitle.text = DateFormatter.dMMMMyyyy.string(from: deadline)
            }
        }
    }

    // MARK: -private
    
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
        label.tintColor = Assets.Colors.Label.primary.color
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()

    private lazy var subtitle: UILabel = {
        let label = UILabel()
        label.textColor = Assets.Colors.Color.blue.color
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()

    private lazy var deadlineSwitch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        return sw
    }()

    private func setupView() {
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])

        contentView.addArrangedSubview(titleStack)
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        titleStack.addArrangedSubview(title)
        titleStack.addArrangedSubview(subtitle)
        contentView.addArrangedSubview(deadlineSwitch)
    }

    @objc
    private func switchChanged(mySwitch: UISwitch) {
        changeDeadline?(mySwitch.isOn, nil)
        
    }

    @objc
    private func didTapSubtitle(_ sender: UITapGestureRecognizer) {
        expandCalendar?()
    }
}
