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
    /// The coordinator to dismiss when the modal's cancellation button is tapped, if any.
    /// Set by ``SheetStackModifier`` depending on ``SheetConfiguration/showsCloseButton``;
    /// consumed by ``NavigationContainerView`` to render the toolbar button from *inside*
    /// its own `NavigationStack`.
    var sheetCloseCoordinator: SheetCoordinatorProtocol? {
        get { self[SheetCloseCoordinatorKey.self] }
        set { self[SheetCloseCoordinatorKey.self] = newValue }
    }
}

private struct SheetModalNavigationModifier: ViewModifier {
    @Environment(\.sheetCloseCoordinator) private var coordinator

    func body(content: Content) -> some View {
        content
            .toolbar {
                if let coordinator {
                    CancelToolbarItem {
                        coordinator.hideSheet()
                    }
                }
            }
    }
}

struct CancelToolbarItem: ToolbarContent {
    let action: @MainActor () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            if #available(iOS 26.0, *) {
                Button(role: .cancel) {
                    action()
                }
            } else {
                Button(role: .cancel, action: {
                    action()
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
