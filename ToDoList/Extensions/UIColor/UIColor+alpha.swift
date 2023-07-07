//
//  UIColor+alpha.swift
//

import UIKit

extension UIColor {
    var alpha: CGFloat? {
        var alpha: CGFloat = 0
        guard getRed(nil, green: nil, blue: nil, alpha: &alpha) else { return nil }
        return alpha
    }
}
