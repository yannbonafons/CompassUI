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

/// Boxes a cancel action so it can flow through a `PreferenceKey` (closures aren't `Equatable`).
/// Identity-based equality via `id` lets `onPreferenceChange` fire only when a different action is set.
private struct SheetCancelActionContainer: Equatable {
    let id = UUID()
    let action: @MainActor () -> Void

    static func == (lhs: SheetCancelActionContainer, rhs: SheetCancelActionContainer) -> Bool {
        lhs.id == rhs.id
    }
}

private struct SheetCancelActionPreferenceKey: PreferenceKey {
    static var defaultValue: SheetCancelActionContainer? { nil }

    static func reduce(value: inout SheetCancelActionContainer?, nextValue: () -> SheetCancelActionContainer?) {
        if let next = nextValue() { value = next }
    }
}

private struct SheetModalNavigationModifier: ViewModifier {
    @Environment(\.sheetCloseCoordinator) private var coordinator
    @State private var sheetCancelActionContainer: SheetCancelActionContainer?

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(SheetCancelActionPreferenceKey.self) { sheetCancelActionContainer in
                self.sheetCancelActionContainer = sheetCancelActionContainer
            }
            .toolbar {
                if let coordinator {
                    CancelToolbarItem {
                        if let sheetCancelActionContainer {
                            sheetCancelActionContainer.action()
                        } else {
                            coordinator.hideSheet()
                        }
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

    /// Overrides the default cancellation action of the sheet-modal toolbar button for the receiver's subtree.
    /// When set, tapping the cancel button runs `action` instead of calling ``SheetCoordinatorProtocol/hideSheet()``.
    /// Apply this from inside a Scene (closest to its ViewModel) to customize dismissal behavior.
    public func onSheetCancel(_ action: @escaping @MainActor () -> Void) -> some View {
        preference(key: SheetCancelActionPreferenceKey.self,
                   value: SheetCancelActionContainer(action: action))
    }
}
