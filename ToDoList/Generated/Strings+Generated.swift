// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum TaskDetails {
    internal enum Deadline {
      /// Сделать до
      internal static let title = L10n.tr("Localizable", "TaskDetails.deadline.title", fallback: "Сделать до")
    }
    internal enum DeleteButton {
      /// Удалить
      internal static let delete = L10n.tr("Localizable", "TaskDetails.deleteButton.delete", fallback: "Удалить")
    }
    internal enum Importance {
      /// Важность
      internal static let title = L10n.tr("Localizable", "TaskDetails.importance.title", fallback: "Важность")
      internal enum Slider {
        /// Нет
        internal static let no = L10n.tr("Localizable", "TaskDetails.importance.slider.no", fallback: "Нет")
      }
    }
    internal enum NavBar {
      /// Дело
      internal static let title = L10n.tr("Localizable", "TaskDetails.navBar.title", fallback: "Дело")
      internal enum LeftButton {
        /// Отменить
        internal static let title = L10n.tr("Localizable", "TaskDetails.navBar.leftButton.title", fallback: "Отменить")
      }
      internal enum RightButton {
        /// Cохранить
        internal static let title = L10n.tr("Localizable", "TaskDetails.navBar.rightButton.title", fallback: "Cохранить")
      }
    }
    internal enum TextView {
      /// Что надо сделать?
      internal static let placeholder = L10n.tr("Localizable", "TaskDetails.textView.placeholder", fallback: "Что надо сделать?")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
