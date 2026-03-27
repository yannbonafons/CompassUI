//
//  SheetStackModifier.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 19/03/2026.
//

import SwiftUI

private struct SheetStackModifier<CoordinatorType: StackableSheetProtocol>: ViewModifier {
    @Bindable var coordinator: CoordinatorType
    let index: Int

    func body(content: Content) -> some View {
        content
            .sheet(item: Binding(
                get: {
                    coordinator.sheetRoutes.indices.contains(index) ? coordinator.sheetRoutes[index] : nil
                },
                set: { newValue in
                    if newValue == nil && coordinator.sheetRoutes.indices.contains(index) {
                        // We remove current route and all the ones above
                        coordinator.sheetRoutes.removeSubrange(index...)
                    }
                }
            )) { route in
                route.destinationView
                    .presentationDetents(route.configuration.detents)
                    // We forward the same coordinator to the next view
                    .modifier(SheetStackModifier<CoordinatorType>(coordinator: coordinator,
                                                                  index: index + 1))
            }
    }
}

extension View {
    public func stackableSheets<CoordinatorType: StackableSheetProtocol>(coordinator: CoordinatorType) -> some View {
        self.modifier(SheetStackModifier(coordinator: coordinator, index: 0))
    }
}
