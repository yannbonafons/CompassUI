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
    /// Which column sits on top of the collapsed stack when the split view is horizontally compact (e.g. iPhone portrait).
    public var preferredCompactColumn: NavigationSplitViewColumn = .sidebar

    public init() {}

    /// Displays `route` in the detail column, replacing any route currently shown there.
    /// In a horizontally compact environment, this also brings the detail column to the front, mirroring a push.
    public func show<RouteType: SplitRoute>(_ route: RouteType, animated: Bool = false) {
        execute(animated: animated) {
            selectedRoute = route.erased()
            preferredCompactColumn = .detail
        }
    }

    /// Clears the detail column, showing the container's empty placeholder again.
    /// In a horizontally compact environment, this also brings the sidebar column back to the front, mirroring a pop.
    public func dismissDetail(animated: Bool = false) {
        execute(animated: animated) {
            selectedRoute = nil
            preferredCompactColumn = .sidebar
        }
    }
}
