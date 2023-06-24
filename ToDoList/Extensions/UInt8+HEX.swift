//
//  UInt8+HEX.swift
//

import Foundation

extension UInt8 {
    var hexa: String {
        let value = String(self, radix: 16, uppercase: true)
        return (self < 16 ? "0": "") + value
    }
}
