//
//  SheetStackModifier.swift
//  CompassUI
//
//  Created by Yann Bonafons on 19/03/2026.
//

import SwiftUI

private struct SheetStackModifier<CoordinatorType: StackableSheetProtocol & SheetCoordinatorProtocol,
                                  AlertCoordinatorType: AlertCoordinatorProtocol>: ViewModifier {
    @Bindable var sheetCoordinator: CoordinatorType
    let alertCoordinator: AlertCoordinatorType
    let index: Int

    func body(content: Content) -> some View {
        content
            // `content` at `index` presents sheet `index`: it's top-most when no sheet sits above it.
            .alert(coordinator: alertCoordinator,
                   isActive: sheetCoordinator.sheetRoutes.count == index)
            .sheet(item: Binding(
                get: {
                    sheetCoordinator.sheetRoutes.indices.contains(index) ? sheetCoordinator.sheetRoutes[index] : nil
                },
                set: { newValue in
                    if newValue == nil && sheetCoordinator.sheetRoutes.indices.contains(index) {
                        // We remove current route and all the ones above
                        sheetCoordinator.sheetRoutes.removeSubrange(index...)
                    }
                }
            )) { route in
                route.destinationView
                    .environment(\.sheetCloseCoordinator, route.configuration.showsCloseButton ? sheetCoordinator : nil)
                    .presentationDetents(route.configuration.detents)
                    // We forward the same coordinator to the next view
                    .modifier(SheetStackModifier<CoordinatorType, AlertCoordinatorType>(
                        sheetCoordinator: sheetCoordinator,
                        alertCoordinator: alertCoordinator,
                        index: index + 1)
                    )
            }
    }
}

extension View {
    /// Enables stackable sheet presentation. Apply once, high in the view hierarchy
    /// (e.g., on the root `TabView`). Sheets stack on top of each other automatically.
    public func stackableSheetsAndAlert<CoordinatorType: StackableSheetProtocol & SheetCoordinatorProtocol,
                                        AlertCoordinatorType: AlertCoordinatorProtocol>(sheetCoordinator: CoordinatorType,
                                                                                        alertCoordinator: AlertCoordinatorType) -> some View {
        self.modifier(SheetStackModifier(sheetCoordinator: sheetCoordinator,
                                         alertCoordinator: alertCoordinator,
                                         index: 0))
    }
}
