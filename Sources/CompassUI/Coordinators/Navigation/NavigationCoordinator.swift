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

    public func push<RouteType: NavigationRoute>(_ route: RouteType, animated: Bool = true) {
        execute(animated: animated) {
            path.append(route.erased())
        }
    }

    public func pop(animated: Bool = true) {
        guard !path.isEmpty else {
            print("Cannot pop")
            return
        }
        execute(animated: animated) {
            path.removeLast()
        }
    }

    public func popToRoot(animated: Bool = true) {
        execute(animated: animated) {
            path = NavigationPath()
        }
    }
}
