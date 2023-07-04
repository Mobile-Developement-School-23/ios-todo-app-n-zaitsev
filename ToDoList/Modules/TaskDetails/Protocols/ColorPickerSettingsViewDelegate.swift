//
//  ColorPickerSettingsViewDelegate.swift
//

import UIKit

protocol ColorPickerSettingsViewDelegate: AnyObject {
    func sliderDidChange(color: UIColor?)
    func colorDidChange(color: UIColor?)
}
