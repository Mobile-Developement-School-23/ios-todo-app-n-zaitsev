//
//  ColorPickerViewDelegate.swift
//

import UIKit

protocol ColorPickerViewDelegate: NSObject {
    func colorDidChange(newColor: UIColor?)
}
