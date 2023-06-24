//
//  UIColor+RGB2HEX.swift
//

import UIKit

typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat)

extension UIColor {
    var rgb: RGB? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        guard getRed(&r, green: &g, blue: &b, alpha: nil) else { return nil }
        return (r,g,b)
    }

    var hexa: String? {
        guard let (r,g,b) = rgb else { return nil }
        return "#" + UInt8(r*255).hexa + UInt8(g*255).hexa + UInt8(b*255).hexa
    }
}

