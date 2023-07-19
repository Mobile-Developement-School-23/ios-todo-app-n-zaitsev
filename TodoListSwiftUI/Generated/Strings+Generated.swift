// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum TaskList {
    /// Мои дела
    internal static let title = L10n.tr("Localizable", "TaskList.title", fallback: "Мои дела")
    internal enum ContextMenu {
      internal enum Delete {
        /// Удалить
        internal static let title = L10n.tr("Localizable", "TaskList.ContextMenu.delete.title", fallback: "Удалить")
      }
      internal enum Done {
        /// Изменить статус
        internal static let title = L10n.tr("Localizable", "TaskList.ContextMenu.done.title", fallback: "Изменить статус")
      }
      internal enum Edit {
        /// Редактировать
        internal static let title = L10n.tr("Localizable", "TaskList.ContextMenu.edit.title", fallback: "Редактировать")
      }
    }
    internal enum CreateNew {
      /// Новое
      internal static let title = L10n.tr("Localizable", "TaskList.CreateNew.title", fallback: "Новое")
    }
    internal enum InfoCell {
      internal enum Action {
        internal enum Hide {
          /// Спрятать
          internal static let title = L10n.tr("Localizable", "TaskList.InfoCell.action.hide.title", fallback: "Спрятать")
        }
        internal enum Show {
          /// Показать
          internal static let title = L10n.tr("Localizable", "TaskList.InfoCell.action.show.title", fallback: "Показать")
        }
      }
      internal enum Info {
        /// Выполнено — %i
        internal static func title(_ p1: Int) -> String {
          return L10n.tr("Localizable", "TaskList.InfoCell.info.title", p1, fallback: "Выполнено — %i")
        }
      }
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
