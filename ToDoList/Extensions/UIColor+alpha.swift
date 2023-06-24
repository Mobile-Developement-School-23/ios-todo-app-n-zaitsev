//
//  UIColor+alpha.swift
//

import UIKit

extension UIColor {
    var alpha: CGFloat? {
        var a: CGFloat = 0
        guard getRed(nil, green: nil, blue: nil, alpha: &a) else { return nil }
        return a
    }
}
