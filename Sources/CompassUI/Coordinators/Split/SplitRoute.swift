//
//  SplitRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 21/09/2026.
//

import SwiftUI

/// A route displayed in the detail column of a `NavigationSplitView`. Define an enum case per destination,
/// the same way you would for ``NavigationRoute``.
public protocol SplitRoute: Route {}

/// Type-erased ``SplitRoute``, used internally by ``SplitCoordinator`` to store the selected route.
public struct AnySplitRoute: @MainActor AnyRoute {
    public let id: AnyHashable
    let destinationView: AnyView

    public init(id: AnyHashable, destinationView: AnyView) {
        self.id = id
        self.destinationView = destinationView
    }
}

extension SplitRoute {
    /// Type-erases this route for storage in ``SplitCoordinator``.
    public func erased() -> AnySplitRoute {
        AnySplitRoute(
            id: AnyHashable(self),
            destinationView: AnyView(destinationView)
        )
    }
}
