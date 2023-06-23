//
//  TaskDetailsView.swift
//

import UIKit

class TaskDetailsView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupTextView()
        setupContentView()
        contentView.addArrangedSubview(detailsView)
        setupDeleteButton()
        setupClosures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var detailsViewDelegate: TaskDetailsViewProtocol?

    func setup(text: String, color: UIColor, importance: TodoItem.Importance, deadline: Date?) {
        textView.setup(text: text, with: color)
        detailsView.setup(color: color, importance: importance, deadline: deadline)
    }
    
    func update(deadline: Date?) {
        detailsView.update(deadline: deadline)
    }
    
    func setDeleteButton(enable: Bool) {
        deleteButton.setEnable(enable)
    }

    // MARK: -private
    
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
        detailsView.deadlineDidChange = { [weak self] isOn, deadline in
            self?.detailsViewDelegate?.deadlineDidChange(switchIsOn: isOn, newDeadline: deadline)
        }
        detailsView.importanceValueDidChange = { [weak self] segment in
            self?.detailsViewDelegate?.importanceValueDidChange(segment: segment)
        }
        deleteButton.buttonDidTap = { [weak self] in
            self?.detailsViewDelegate?.deleteButtonDidTap()
        }
        detailsView.colorDidChange = { [weak self] newColor in
            self?.detailsViewDelegate?.colorDidChange(newColor: newColor)
            self?.textView.update(color: newColor)
        }
    }
}
