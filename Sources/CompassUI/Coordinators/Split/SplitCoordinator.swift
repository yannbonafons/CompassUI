//
//  SplitCoordinator.swift
//  CompassUI
//
//  Created by Yann Bonafons on 21/09/2026.
//

import SwiftUI

/// Manages the content and detail columns of a `NavigationSplitView`. Created automatically
/// by ``SplitContainerView`` — you rarely need to instantiate this yourself.
@Observable
public final class SplitCoordinator: AnimatedCoordinator, @MainActor HashableProtocol {
    /// The route currently displayed in the content column, or `nil` if none is selected.
    /// Always `nil` when the enclosing ``SplitContainerView`` has no content column.
    public private(set) var selectedContentRoute: AnySplitRoute?
    /// The route currently displayed in the detail column, or `nil` if none is selected.
    public private(set) var selectedDetailRoute: AnySplitRoute?
    /// Which column sits on top of the collapsed stack when the split view is horizontally compact (e.g. iPhone portrait).
    public var preferredCompactColumn: NavigationSplitViewColumn = .sidebar

    public init() {}

    /// Displays `route` in the content column, replacing any route currently shown there.
    /// In a horizontally compact environment, this also brings the content column to the front, mirroring a push.
    /// Only meaningful when the enclosing ``SplitContainerView`` has a content column.
    public func showContent<RouteType: SplitRoute>(_ route: RouteType, animated: Bool = false) {
        execute(animated: animated) {
            selectedContentRoute = route.erased()
            selectedDetailRoute = nil
            preferredCompactColumn = .content
        }
    }

    /// Clears the content column, showing the container's content placeholder again.
    /// Also clears the detail column, since its selection depends on the content.
    /// In a horizontally compact environment, this also brings the sidebar column back to the front, mirroring a pop.
    public func dismissContent(animated: Bool = false) {
        execute(animated: animated) {
            selectedContentRoute = nil
            selectedDetailRoute = nil
            preferredCompactColumn = .sidebar
        }
    }

    /// Displays `route` in the detail column, replacing any route currently shown there.
    /// In a horizontally compact environment, this also brings the detail column to the front, mirroring a push.
    public func showDetail<RouteType: SplitRoute>(_ route: RouteType, animated: Bool = false) {
        execute(animated: animated) {
            selectedDetailRoute = route.erased()
            preferredCompactColumn = .detail
        }
    }

    /// Clears the detail column, showing the container's empty placeholder again.
    /// In a horizontally compact environment, this brings the content column back to the front
    /// when one is displayed, or the sidebar otherwise, mirroring a pop.
    public func dismissDetail(animated: Bool = false) {
        execute(animated: animated) {
            selectedDetailRoute = nil
            preferredCompactColumn = selectedContentRoute == nil ? .sidebar : .content
        }
    }
}
