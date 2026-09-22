//
//  ModalNavigationModifier.swift
//  CompassUI
//
//  Created by Yann Bonafons on 19/03/2026.
//

import SwiftUI

private struct SheetModalNavigationModifier: ViewModifier {
    let coordinator: SheetCoordinatorProtocol

    func body(content: Content) -> some View {
        VStack {
            content
        }
        .toolbar {
            CancelToolbarItem {
                coordinator.hideSheet()
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
    func asModal(coordinator: SheetCoordinatorProtocol) -> some View {
        self.modifier(SheetModalNavigationModifier(coordinator: coordinator))
    }
}
