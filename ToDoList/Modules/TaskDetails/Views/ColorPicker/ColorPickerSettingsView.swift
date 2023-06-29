//
//  ColorPickerSettingsView.swift
//

import UIKit

final class ColorPickerSettingsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        colorPicker.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(color: UIColor?, alpha: CGFloat? = nil) {
        currentColor = color
        if let alpha {
            alphaSlider.value = Float(alpha)
        }
    }

    weak var delegate: ColorPickerSettingsViewDelegate?

    private var currentColor: UIColor?

    private lazy var contentView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var colorPicker = ColorPickerView()

    private lazy var alphaSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(sliderDidChange), for: .valueChanged)
        translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
        contentView.addArrangedSubview(colorPicker)
        colorPicker.heightAnchor.constraint(equalToConstant: 36).isActive = true
        colorPicker.layer.cornerRadius = 8
        colorPicker.clipsToBounds = true
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addArrangedSubview(alphaSlider)
    }

    @objc
    private func sliderDidChange(_ slider: UISlider) {
        delegate?.sliderDidChange(color: currentColor?.withAlphaComponent(CGFloat(slider.value)))
    }
}

extension ColorPickerSettingsView: ColorPickerViewDelegate {
    func colorDidChange(newColor: UIColor?) {
        delegate?.colorDidChange(color: newColor?.withAlphaComponent(CGFloat(alphaSlider.value)))
    }
}
