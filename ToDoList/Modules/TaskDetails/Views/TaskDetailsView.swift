//
//  TaskDetailsView.swift
//

import UIKit

class TaskDetailsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
        setupContentView()
        setupTextView()
        contentView.addArrangedSubview(detailsView)
        setupDeleteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static let spacing: CGFloat = 16

    private lazy var scrollView = UIScrollView()
    private lazy var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Self.spacing
        return stackView
    }()

    private lazy var textView = TaskDetailsTextView()

    private lazy var detailsView = TaskDetailsDetailsView()

    private lazy var deleteButton = TextDetailsDeleteButton()
    
    private func setupScrollView() {
        scrollView.backgroundColor = Assets.Colors.Back.primary.color
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Self.spacing),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.spacing),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Self.spacing),
        ])
    }

    private func setupTextView() {
        contentView.addArrangedSubview(textView)
        textView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }

    private func setupDeleteButton() {
        contentView.addArrangedSubview(deleteButton)
        deleteButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
}
