//
//  AlertConfiguration.swift
//  CompassUI
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

/// Describes an alert presented via `.alert(coordinator:)`: its title/message, an optional
/// text field, and its action buttons.
public struct AlertConfiguration {
    /// Configuration for the optional text field displayed inside the alert.
    public struct TexFieldInfo {
        /// The placeholder text shown while the field is empty.
        public let placeholder: LocalizedStringResource
        /// The keyboard type used while editing the text field.
        public let keyboardType: UIKeyboardType

        public init(placeholder: LocalizedStringResource,
                    keyboardType: UIKeyboardType) {
            self.placeholder = placeholder
            self.keyboardType = keyboardType
        }
    }

    /// The alert's title and/or message.
    public let titleAndMessageType: TitleAndMessageType
    /// The buttons displayed in the alert.
    public let actions: [AlertAction]
    /// Configuration for an optional text field. When `nil`, no text field is shown.
    public let textFieldInfo: TexFieldInfo?

    public init(titleAndMessageType: TitleAndMessageType,
                textFieldInfo: TexFieldInfo? = nil,
                actions: [AlertAction]) {
        self.titleAndMessageType = titleAndMessageType
        self.textFieldInfo = textFieldInfo
        self.actions = actions
    }
}
