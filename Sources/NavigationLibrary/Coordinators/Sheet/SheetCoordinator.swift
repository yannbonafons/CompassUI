//
//  SheetCoordinator.swift
//  NavigationLibrary
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
