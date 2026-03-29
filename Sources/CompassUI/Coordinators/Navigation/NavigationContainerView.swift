//
//  NavigationContainerView.swift
//  CompassUI
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI

/// SwiftUI equivalent of `UINavigationController`. Wraps a `NavigationStack` and creates
/// its own ``NavigationCoordinator`` internally. The content closure receives a ``RouterContext``
/// combining this local coordinator with the shared ``RouterGlobalContext``.
public struct NavigationContainerView<RootViewType: View>: View {
    @State private var navigationCoordinator = NavigationCoordinator()
    private let globalContext: RouterGlobalContext
    private let contentView: (RouterContext) -> RootViewType

    private var routerContext: RouterContext {
        RouterContext(navigationCoordinator: navigationCoordinator,
                      globalContext: globalContext)
    }

    public init(globalContext: RouterGlobalContext,
                @ViewBuilder contentView: @escaping (RouterContext) -> RootViewType) {
        self.globalContext = globalContext
        self.contentView = contentView
    }

    public var body: some View {
        NavigationStack(path: $navigationCoordinator.path) {
            contentView(routerContext)
                .navigationDestination(for: AnyNavigationRoute.self) { route in
                    route.destinationView
                }
        }
    }
}
