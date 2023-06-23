//
//  TaskDetailsColorPicker.swift
//

import UIKit

class TaskDetailsColorPicker: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        colorPicker.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var colorDidChange: ((UIColor) -> ())?

    func setup(color: UIColor) {
        colorPicker.selectedColor = color
    }

    // MARK: -private
    
    private lazy var colorPicker: UIColorWell = {
       let picker = UIColorWell()
        picker.selectedColor = .black
        picker.supportsAlpha = true
        return picker
    }()

    private lazy var contentView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = L10n.TaskDetails.ColorPicker.title
        label.tintColor = Assets.Colors.Label.primary.color
        return label
    }()

    private func setupView() {
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])

        contentView.addArrangedSubview(title)
        contentView.addArrangedSubview(colorPicker)
    }

    @objc
    private func colorChanged() {
        if let color = colorPicker.selectedColor {
            print(color)
            colorDidChange?(color)
        }
    }
}
