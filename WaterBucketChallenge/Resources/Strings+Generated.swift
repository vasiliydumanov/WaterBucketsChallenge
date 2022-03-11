// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Screen {
    internal enum Inputs {
      internal enum Alert {
        /// OK
        internal static let buttonTitle = L10n.tr("Localizable", "Screen.Inputs.Alert.ButtonTitle")
      }
      internal enum Form {
        /// Solve
        internal static let buttonTitle = L10n.tr("Localizable", "Screen.Inputs.Form.ButtonTitle")
        /// Enter Input Data
        internal static let title = L10n.tr("Localizable", "Screen.Inputs.Form.Title")
      }
    }
    internal enum Solution {
      internal enum Animated {
        /// Reset Animation
        internal static let resetAnimation = L10n.tr("Localizable", "Screen.Solution.Animated.ResetAnimation")
        /// Start Animation
        internal static let startAnimation = L10n.tr("Localizable", "Screen.Solution.Animated.StartAnimation")
      }
      internal enum Table {
        internal enum StepAction {
          /// Empty bucket %@
          internal static func empty(_ p1: Any) -> String {
            return L10n.tr("Localizable", "Screen.Solution.Table.StepAction.Empty", String(describing: p1))
          }
          /// Fill bucket %@
          internal static func fill(_ p1: Any) -> String {
            return L10n.tr("Localizable", "Screen.Solution.Table.StepAction.Fill", String(describing: p1))
          }
          /// Transfer bucket %@ to bucket %@
          internal static func transfer(_ p1: Any, _ p2: Any) -> String {
            return L10n.tr("Localizable", "Screen.Solution.Table.StepAction.Transfer", String(describing: p1), String(describing: p2))
          }
        }
      }
      internal enum Tabs {
        /// Animated
        internal static let animated = L10n.tr("Localizable", "Screen.Solution.Tabs.Animated")
        /// Table
        internal static let table = L10n.tr("Localizable", "Screen.Solution.Tabs.Table")
      }
    }
  }

  internal enum Solution {
    internal enum Error {
      /// At least one bucket should have volume greater than Z
      internal static let bucketsTooSmall = L10n.tr("Localizable", "Solution.Error.BucketsTooSmall")
      /// The problem is not solvable
      internal static let unsolvableInputs = L10n.tr("Localizable", "Solution.Error.UnsolvableInputs")
      /// Inputs cannot be equal to 0
      internal static let zeroInputs = L10n.tr("Localizable", "Solution.Error.ZeroInputs")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
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
