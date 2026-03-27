//
//  NavigationRoute.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 17/03/2026.
//

import SwiftUI

public protocol NavigationRoute: Route {}

struct AnyNavigationRoute: AnyRoute {
    let id: AnyHashable
    let destinationView: AnyView

    init(id: AnyHashable, destinationView: AnyView) {
        self.id = id
        self.destinationView = destinationView
    }
}

extension NavigationRoute {
    func erased() -> AnyNavigationRoute {
        AnyNavigationRoute(id: AnyHashable(self),
                           destinationView: AnyView(destinationView))
    }
}
