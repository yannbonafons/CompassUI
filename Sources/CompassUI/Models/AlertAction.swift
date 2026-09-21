//
//  AlertAction.swift
//  CompassUI
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

/// A single button displayed in an alert presented via ``AlertCoordinator``.
public struct AlertAction: Identifiable {
    public let id = UUID()
    /// The button's label.
    public let actionMessage: LocalizedStringResource
    /// Called when the button is tapped. Receives the text field value, or an empty string if no text field.
    public let action: ((String) -> Void)?
    /// The button's role (e.g. `.cancel`, `.destructive`), or `nil` for a default button.
    public let role: ButtonRole?

    public init(actionMessage: LocalizedStringResource,
                action: ((String) -> Void)? = nil,
                role: ButtonRole? = nil) {
        self.actionMessage = actionMessage
        self.action = action
        self.role = role
    }
}
