//
//  CALayer+ColorOfPoint.swift
//

import UIKit

extension CALayer {
    func colorOfPoint(point: CGPoint) -> UIColor? {
        /// Our pixel data
        var pixel: [UInt8] = [0, 0, 0, 0]
        /// The device's color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        /// Get the pixel data already multiplied by the alpha value
        let bitmapInfo = CGBitmapInfo(
            rawValue: CGImageAlphaInfo.premultipliedLast.rawValue
        )

        /// try to get a context of 1x1 pixel by getting 8 bits
        /// per component in the given color space
        guard let context = CGContext(
            data: &pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else { return nil }
        context.translateBy(x: -point.x, y: -point.y)

        render(in: context)

        let red = CGFloat(pixel[0]) / 255.0
        let green = CGFloat(pixel[1]) / 255.0
        let blue = CGFloat(pixel[2]) / 255.0
        let alpha = CGFloat(pixel[3]) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
