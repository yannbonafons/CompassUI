//
//  CustomAlertModifier.swift
//  CompassUI
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

/// Backing view modifier for `.alert(coordinator:)`. Renders the coordinator's current
/// ``AlertConfiguration`` as a native SwiftUI alert, forwarding the optional text field value.
private struct CustomAlertModifier<CoordinatorType: AlertCoordinatorProtocol>: ViewModifier {
    /// Coordinator for the alert
    @Bindable var coordinator: CoordinatorType
    /// Text set in the Textfield of the alert
    @State private var text: String = ""
    /// Only the top-most presenter may show the alert, otherwise SwiftUI dismisses the sheets above it.
    let isActive: Bool

    // Driving `isPresented` off a real binding (rather than `.constant(true)` with the
    // `.alert` attached only inside an `if let`) keeps SwiftUI's presentation state in
    // sync with the coordinator, so the next queued alert can present after this one closes.
    private var isPresented: Binding<Bool> {
        Binding(
            get: {
                isActive && coordinator.alertConfiguration != nil
            },
            set: { newValue in
                if !newValue {
                    coordinator.hideAlert()
                }
            }
        )
    }

    func body(content: Content) -> some View {
        content
            .alert(coordinator.alertConfiguration?.titleAndMessageType.title ?? "",
                   isPresented: isPresented,
                   actions: {
                if let conf = coordinator.alertConfiguration {
                    if let confgurationTextFieldInfo = conf.textFieldInfo {
                        TextField(String(localized: confgurationTextFieldInfo.placeholder),
                                  text: $text)
                        .keyboardType(confgurationTextFieldInfo.keyboardType)
                    }
                    ForEach(conf.actions) { action in
                        Button(role: action.role,
                               action: {
                            action.action?(text)
                            text = ""
                        },
                               label: {
                            ActionView(actionInfo: .text(action.actionMessage))
                        })
                    }
                }
            }, message: {
                if let message = coordinator.alertConfiguration?.titleAndMessageType.message {
                    Text(message)
                }
            })
    }
}

extension View {
    /// Enables alert presentation. Apply once, high in the view hierarchy (e.g., on the root `TabView`).
    func alert<CoordinatorType: AlertCoordinatorProtocol>(coordinator: CoordinatorType,
                                                          isActive: Bool) -> some View {
        modifier(CustomAlertModifier(coordinator: coordinator,
                                     isActive: isActive))
    }
}
