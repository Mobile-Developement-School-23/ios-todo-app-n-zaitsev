//
//  TaskDetailsView.swift
//

import UIKit
import FileCache

final class TaskDetailsView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupTextView()
        setupContentView()
        contentView.addArrangedSubview(detailsView)
        setupDeleteButton()
        setupClosures()
        detailsView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var detailsViewDelegate: TaskDetailsViewDelegate?

    func setup(text: String, color: UIColor?, importance: TodoItem.Importance, deadline: Date?) {
        textView.setup(text: text, with: color)
        detailsView.setup(color: color, importance: importance, deadline: deadline)
    }

    func update(deadline: Date?) {
        detailsView.update(deadline: deadline)
    }

    func setDeleteButton(enable: Bool) {
        deleteButton.setEnable(enable)
    }

    // MARK: - private

    private static let spacing: CGFloat = 16

    private lazy var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Self.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var textView = TaskDetailsTextView()
    private lazy var detailsView = TaskDetailsDetailsView()
    private lazy var deleteButton = TextDetailsDeleteButton()

    private func setupContentView() {
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: Self.spacing),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Self.spacing),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.spacing),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Self.spacing),
            contentView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: -32)
        ])
    }

    private func setupTextView() {
        contentView.addArrangedSubview(textView)
    }

    private func setupDeleteButton() {
        contentView.addArrangedSubview(deleteButton)
        deleteButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }

    private func setupClosures() {
        textView.textViewDidChange = { [weak self] text in
            self?.detailsViewDelegate?.textViewDidChange(text: text)
        }

        deleteButton.buttonDidTap = { [weak self] in
            self?.detailsViewDelegate?.deleteButtonDidTap()
        }
    }
}

extension TaskDetailsView: TaskDetailsDetailsViewDelegate {
    func deadlineDidChange(switchIsOn: Bool, newDeadline: Date?) {
        detailsViewDelegate?.deadlineDidChange(switchIsOn: switchIsOn, newDeadline: newDeadline)
    }

    func importanceValueDidChange(segment: Int) {
        detailsViewDelegate?.importanceValueDidChange(segment: segment)
    }

    func colorDidChange(newColor: UIColor?) {
        detailsViewDelegate?.colorDidChange(newColor: newColor)
        textView.update(color: newColor)
    }
}
