//
//  SheetCoordinator.swift
//  CompassUI
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI

public protocol StackableSheetProtocol: AnyObject, Observable {
    var sheetRoutes: [AnySheetRoute] { get set }
}

public protocol SheetCoordinatorProtocol {
    func hideSheet()
}

/// Manages a stack of sheets presented on top of each other.
/// Shared across the app via ``AppCoordinator`` — apply `.stackableSheets(coordinator:)`
/// once at the root level (e.g., on your `TabView`).
@Observable
public final class SheetCoordinator: SheetCoordinatorProtocol, StackableSheetProtocol, AnimatedCoordinator, HashableProtocol {
    public var sheetRoutes: [AnySheetRoute] = []

    public init() {}

    public func showSheet<SheetRouteType: SheetRoute>(_ route: SheetRouteType, animated: Bool = true) {
        execute(animated: animated) {
            sheetRoutes.append(route.erased())
        }
    }

    public func hideSheet() {
        hideSheet(animated: true)
    }

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

    public func hideAll(animated: Bool = true) {
        execute(animated: animated) {
            sheetRoutes = []
        }
    }
}
