//
//  EmptyRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 21/09/2026.
//

import SwiftUI

/// A no-op route conforming to ``SheetRoute``, ``NavigationRoute``, and ``SplitRoute`` at once.
/// Used as the default associated type in ``RouterProtocol`` so a scene only needs to specify
/// the route types it actually uses (navigation, sheet, and/or split).
public struct EmptyRoute: @MainActor SheetRoute, @MainActor NavigationRoute, @MainActor SplitRoute {
    public var destinationView: EmptyView {
        EmptyView()
    }
}
