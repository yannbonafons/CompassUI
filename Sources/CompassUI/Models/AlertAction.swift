//
//  AlertAction.swift
//  CompassUI
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

public struct AlertAction: Identifiable {
    public let id = UUID()
    public let actionMessage: LocalizedStringResource
    /// Called when the button is tapped. Receives the text field value, or an empty string if no text field.
    public let action: ((String) -> Void)?
    public let role: ButtonRole?

    public init(actionMessage: LocalizedStringResource,
                action: ((String) -> Void)? = nil,
                role: ButtonRole? = nil) {
        self.actionMessage = actionMessage
        self.action = action
        self.role = role
    }
}
