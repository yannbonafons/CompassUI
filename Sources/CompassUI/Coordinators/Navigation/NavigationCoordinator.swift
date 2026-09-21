//
//  NavigationCoordinator.swift
//  CompassUI
//
//  Created by Yann Bonafons on 15/03/2026.
//

import SwiftUI

/// Manages the path of a single `NavigationStack`. Created automatically
/// by ``NavigationContainerView`` — you rarely need to instantiate this yourself.
@Observable
public final class NavigationCoordinator: AnimatedCoordinator, @MainActor HashableProtocol {
    public var path = NavigationPath()

    public init() {}

    /// Pushes `route` onto the navigation stack.
    public func push<RouteType: NavigationRoute>(_ route: RouteType, animated: Bool = true) {
        execute(animated: animated) {
            path.append(route.erased())
        }
    }

    /// Pops the top-most route off the stack. No-ops (and logs) if the stack is already empty.
    public func pop(animated: Bool = true) {
        guard !path.isEmpty else {
            print("Cannot pop")
            return
        }
        execute(animated: animated) {
            path.removeLast()
        }
    }

    /// Pops back to the root of the stack, removing all pushed routes.
    public func popToRoot(animated: Bool = true) {
        execute(animated: animated) {
            path = NavigationPath()
        }
    }
}
