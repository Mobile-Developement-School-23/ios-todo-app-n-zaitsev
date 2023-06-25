//
//  UIViewController+Keyboard.swift
//

import UIKit

extension UIViewController {
    func addGestureRecognizerToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
