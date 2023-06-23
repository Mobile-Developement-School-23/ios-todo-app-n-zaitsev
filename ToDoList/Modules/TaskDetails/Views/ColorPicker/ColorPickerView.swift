//
//  ColorPickerView.swift
//

import UIKit

class ColorPickerView: UIView {
    
    let gradientLayer = CAGradientLayer()

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setUpGradientLayerIfNeeded()
    }

    weak var delegate: ColorPickerViewDelegate?

    private func setUpGradientLayerIfNeeded() {
        guard gradientLayer.superlayer == nil else { return }

        gradientLayer.colors = [
            UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor,
            UIColor(red: 1, green: 1, blue: 0, alpha: 1).cgColor,
            UIColor(red: 0, green: 1, blue: 0, alpha: 1).cgColor,
            UIColor(red: 0, green: 1, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0, green: 0, blue: 1, alpha: 1).cgColor,
            UIColor(red: 1, green: 0, blue: 1, alpha: 1).cgColor,
            UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
        ]

        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorDidChange)))
        addGestureRecognizer((UIPanGestureRecognizer(target: self, action: #selector(colorDidChange))))
    }

    @objc
    private func colorDidChange(_ gestureRecognizer: UIGestureRecognizer) {
        guard let color = gradientLayer.colorOfPoint(point: gestureRecognizer.location(in: self)) else { return }
        delegate?.colorDidChange(newColor: color)
    }
}
