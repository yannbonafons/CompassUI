//
//  ModalNavigationModifier.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 19/03/2026.
//

import SwiftUI

struct ModalNavigationModifier: ViewModifier {
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
            Button(role: .cancel, action: {
                action()
            }, label: {
                Text("Cancel")
            })
        }
    }
}

extension View {
    func asModal(coordinator: SheetCoordinatorProtocol) -> some View {
        self.modifier(ModalNavigationModifier(coordinator: coordinator))
    }
}
