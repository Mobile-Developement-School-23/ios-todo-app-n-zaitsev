//
//  UIColor+HEX.swift
//

import UIKit

extension UIColor {
    public convenience init?(hex: String?, alpha: CGFloat) {
        guard let hex, hex.hasPrefix("#") else {
            return nil
        }

        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])

        guard hexColor.count == 6 else {
            return nil
        }

        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        guard scanner.scanHexInt64(&hexNumber) else {
            return nil
        }

        let mask = 0x000000FF
        let red   = CGFloat(Int(hexNumber >> 16) & mask) / 255.0
        let green = CGFloat(Int(hexNumber >> 8) & mask) / 255.0
        let blue  = CGFloat(Int(hexNumber) & mask) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
