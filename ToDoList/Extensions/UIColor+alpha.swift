//
//  UIColor+alpha.swift
//

import UIKit

extension UIColor {
    var alpha: CGFloat? {
        var newAlpha: CGFloat = 0
        guard getRed(nil, green: nil, blue: nil, alpha: &newAlpha) else { return nil }
        return newAlpha
    }
}
