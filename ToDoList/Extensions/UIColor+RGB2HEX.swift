//
//  UIColor+RGB2HEX.swift
//

import UIKit

// swiftlint:disable:next large_tuple
typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat)

extension UIColor {
    var rgb: RGB? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        guard getRed(&red, green: &green, blue: &blue, alpha: nil) else { return nil }
        return (red, green, blue)
    }

    var hexa: String? {
        guard let (red, green, blue) = rgb else { return nil }
        return "#" + UInt8(red*255).hexa + UInt8(green*255).hexa + UInt8(blue*255).hexa
    }
}
