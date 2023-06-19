//
//  TaskDetailsImportanceView.swift
//

import UIKit

class TaskDetailsImportanceView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -private

    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = L10n.TaskDetails.Importance.title
        label.tintColor = Assets.Colors.Label.primary.color
        return label
    }()

    private lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.backgroundColor = Assets.Colors.Support.overlay.color
        segment.layer.cornerRadius = 8.91
        let lowPriority = Assets.Assets.Icons.Priority.low.image
        segment.insertSegment(with: lowPriority, at: 0, animated: true)
        segment.insertSegment(withTitle: L10n.TaskDetails.Importance.Slider.no, at: 1, animated: true)
        let hightPriority = Assets.Assets.Icons.Priority.high.image
        segment.insertSegment(with: hightPriority, at: 2, animated: true)
        segment.selectedSegmentIndex = 1
        return segment
    }()

    private lazy var contentView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        return stack
    }()

    private func setupView() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])

        contentView.addArrangedSubview(title)
        contentView.addArrangedSubview(segment)
        segment.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
}
