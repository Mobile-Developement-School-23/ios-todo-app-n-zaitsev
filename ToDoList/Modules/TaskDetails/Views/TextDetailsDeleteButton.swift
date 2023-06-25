//
//  TextDetailsDeleteButton.swift
//

import UIKit

class TextDetailsDeleteButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Assets.Colors.Back.backSecondary.color
        setTitleColor(Assets.Colors.Label.disable.color, for: .normal)
        setTitle(L10n.TaskDetails.DeleteButton.delete, for: .normal)
        layer.cornerRadius = 16
        addTarget(self, action: #selector(onTapAction), for: .touchUpInside)
        titleLabel?.font = Font.body.font
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var buttonDidTap: (() -> ())?

    func setEnable(_ isEnable: Bool) {
        let color = isEnable ? Assets.Colors.Color.red.color : Assets.Colors.Label.disable.color
        self.isEnabled = isEnable
        setTitleColor(color, for: .normal)
    }

    @objc
    private func onTapAction() {
        buttonDidTap?()
    }
}
