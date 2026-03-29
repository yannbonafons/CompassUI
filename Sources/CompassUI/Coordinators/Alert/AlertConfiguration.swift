//
//  AlertConfiguration.swift
//  CompassUI
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

public struct AlertConfiguration {
    public struct TexFieldInfo {
        public let placeholder: LocalizedStringResource
        public let keyboardType: UIKeyboardType

        public init(placeholder: LocalizedStringResource,
                    keyboardType: UIKeyboardType) {
            self.placeholder = placeholder
            self.keyboardType = keyboardType
        }
    }

    public let titleAndMessageType: TitleAndMessageType
    public let actions: [AlertAction]
    public let textFieldInfo: TexFieldInfo?

    public init(titleAndMessageType: TitleAndMessageType,
                textFieldInfo: TexFieldInfo? = nil,
                actions: [AlertAction]) {
        self.titleAndMessageType = titleAndMessageType
        self.textFieldInfo = textFieldInfo
        self.actions = actions
    }
}
