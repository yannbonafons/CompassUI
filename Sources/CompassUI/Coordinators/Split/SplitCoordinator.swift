//
//  SplitCoordinator.swift
//  CompassUI
//
//  Created by Yann Bonafons on 21/09/2026.
//

import SwiftUI

/// Manages the detail column of a `NavigationSplitView`. Created automatically
/// by ``SplitContainerView`` — you rarely need to instantiate this yourself.
@Observable
public final class SplitCoordinator: AnimatedCoordinator, @MainActor HashableProtocol {
    /// The route currently displayed in the detail column, or `nil` if none is selected.
    public private(set) var selectedRoute: AnySplitRoute?

    public init() {}

    /// Displays `route` in the detail column, replacing any route currently shown there.
    public func show<RouteType: SplitRoute>(_ route: RouteType, animated: Bool = false) {
        execute(animated: animated) {
            selectedRoute = route.erased()
        }
    }

    /// Clears the detail column, showing the container's empty placeholder again.
    public func dismissDetail(animated: Bool = false) {
        execute(animated: animated) {
            selectedRoute = nil
        }
    }
}
