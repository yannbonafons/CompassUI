//
//  ModalNavigationModifier.swift
//  CompassUI
//
//  Created by Yann Bonafons on 19/03/2026.
//

import SwiftUI

private struct SheetCloseCoordinatorKey: EnvironmentKey {
    static let defaultValue: SheetCoordinatorProtocol? = nil
}

extension EnvironmentValues {
    /// Set by ``SheetStackModifier`` on the whole sheet route; consumed by ``NavigationContainerView``
    /// on its root content, since `.toolbar` only renders when applied inside the `NavigationStack`.
    var sheetCloseCoordinator: SheetCoordinatorProtocol? {
        get { self[SheetCloseCoordinatorKey.self] }
        set { self[SheetCloseCoordinatorKey.self] = newValue }
    }
}

private struct SheetModalNavigationModifier: ViewModifier {
    @Environment(\.sheetCloseCoordinator) private var coordinator

    func body(content: Content) -> some View {
        if let coordinator {
            content
                .toolbar {
                    CancelToolbarItem(coordinator: coordinator)
                }
        } else {
            content
        }
    }
}

private struct CancelToolbarItem: ToolbarContent {
    let coordinator: SheetCoordinatorProtocol

    var body: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            if #available(iOS 26.0, *) {
                Button(role: .cancel) {
                    coordinator.hideSheet()
                }
            } else {
                Button(role: .cancel, action: {
                    coordinator.hideSheet()
                }, label: {
                    Text("Cancel")
                })
            }
        }
    }
}

extension View {
    /// Renders the cancellation toolbar button set via ``EnvironmentValues/sheetCloseCoordinator``, if any.
    /// Must be applied inside a `NavigationStack` for the button to render in the nav bar.
    func asModal() -> some View {
        self.modifier(SheetModalNavigationModifier())
    }
}
