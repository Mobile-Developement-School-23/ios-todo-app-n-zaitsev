//
//  TaskDetailsImportanceView.swift
//

import UIKit
import FileCache

final class TaskDetailsImportanceView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var onValueChange: ((Int) -> Void)?

    func setup(importance: TodoItem.Importance) {
        switch importance {
        case .unimportant:
            segment.selectedSegmentIndex = Segment.unimportant.rawValue
        case .ordinary:
            segment.selectedSegmentIndex = Segment.ordinary.rawValue
        case .important:
            segment.selectedSegmentIndex = Segment.important.rawValue
        }
    }

    // MARK: - private

    private enum Segment: Int {
        case unimportant
        case ordinary
        case important
    }

    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = L10n.TaskDetails.Importance.title
        label.tintColor = Assets.Colors.Label.labelPrimary.color
        label.font = Font.body.font
        return label
    }()

    private lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.backgroundColor = Assets.Colors.Support.overlay.color
        segment.layer.cornerRadius = 8.91

        let lowPriority = Assets.Assets.Icons.Priority.low.image
        segment.insertSegment(with: lowPriority, at: Segment.unimportant.rawValue, animated: true)
        let title = NSAttributedString(
            string: L10n.TaskDetails.Importance.Slider.no.lowercased(),
            attributes: [.font: Font.subhead.font]
        ).string
        segment.insertSegment(withTitle: title, at: Segment.ordinary.rawValue, animated: true)
        let hightPriority = Assets.Assets.Icons.Priority.high.image
        segment.insertSegment(with: hightPriority, at: Segment.important.rawValue, animated: true)

        segment.selectedSegmentIndex = Segment.ordinary.rawValue
        segment.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        return segment
    }()

    private lazy var contentView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        return stack
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

        contentView.addArrangedSubview(title)
        contentView.addArrangedSubview(segment)
        segment.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }

    @objc
    private func segmentValueChanged(_ segment: UISegmentedControl) {
        onValueChange?(segment.selectedSegmentIndex)
    }
}
