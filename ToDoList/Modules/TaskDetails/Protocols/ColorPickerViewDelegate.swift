//
//  ColorPickerViewDelegate.swift
//

import UIKit

protocol ColorPickerViewDelegate: AnyObject {
    func colorDidChange(newColor: UIColor?)
}
