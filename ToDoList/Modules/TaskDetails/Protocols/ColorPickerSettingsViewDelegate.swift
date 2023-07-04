//
//  ColorPickerSettingsViewDelegate.swift
//

import UIKit

protocol ColorPickerSettingsViewDelegate: NSObject {
    func sliderDidChange(color: UIColor?)
    func colorDidChange(color: UIColor?)
}
