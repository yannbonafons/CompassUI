//
//  NavigationRoute.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 17/03/2026.
//

import SwiftUI

public protocol NavigationRoute: Route {}

public struct AnyNavigationRoute: AnyRoute {
    public let id: AnyHashable
    public let destinationView: AnyView

    public init(id: AnyHashable, destinationView: AnyView) {
        self.id = id
        self.destinationView = destinationView
    }
}

extension NavigationRoute {
    public func erased() -> AnyNavigationRoute {
        AnyNavigationRoute(id: AnyHashable(self),
                           destinationView: AnyView(destinationView))
    }
}
