//
//  SheetCoordinator.swift
//  CompassUI
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI

/// Exposes the current sheet stack for rendering by ``SheetStackModifier``.
public protocol StackableSheetProtocol: AnyObject, Observable {
    /// The currently presented sheets, ordered from the bottom of the stack to the top.
    var sheetRoutes: [AnySheetRoute] { get set }
}

/// Minimal interface for dismissing the top-most sheet, exposed to consumers that only
/// need to close their own sheet (e.g., via ``ModalNavigationModifier``-style helpers).
public protocol SheetCoordinatorProtocol {
    func hideSheet()
}

/// Manages a stack of sheets presented on top of each other.
/// Shared across the app via ``AppCoordinator`` — apply `.stackableSheets(coordinator:)`
/// once at the root level (e.g., on your `TabView`).
@Observable
public final class SheetCoordinator: SheetCoordinatorProtocol, StackableSheetProtocol, AnimatedCoordinator, @MainActor HashableProtocol {
    public var sheetRoutes: [AnySheetRoute] = []

    public init() {}

    /// Presents `route` as a sheet, stacked on top of any sheet already presented.
    public func showSheet<SheetRouteType: SheetRoute>(_ route: SheetRouteType, animated: Bool = true) {
        execute(animated: animated) {
            sheetRoutes.append(route.erased())
        }
    }

    /// Dismisses the top-most sheet. No-ops (and logs) if no sheet is presented.
    public func hideSheet() {
        hideSheet(animated: true)
    }

    /// Dismisses the top-most sheet. No-ops (and logs) if no sheet is presented.
    public func hideSheet(animated: Bool) {
        execute(animated: animated) {
            if !sheetRoutes.isEmpty {
                sheetRoutes.removeLast()
            } else {
                print("No sheet")
            }
        }
    }

    /// Dismisses a specific sheet by identity, regardless of its position in the stack.
    public func hideSheet<SheetRouteType: SheetRoute>(_ route: SheetRouteType, animated: Bool = true) {
        execute(animated: animated) {
            guard let sheetIndex = sheetRoutes.firstIndex(where: { $0.id == route.erased().id }) else {
                return
            }
            sheetRoutes.remove(at: sheetIndex)
        }
    }

    /// Dismisses every currently presented sheet.
    public func hideAll(animated: Bool = true) {
        execute(animated: animated) {
            sheetRoutes = []
        }
    }
}
