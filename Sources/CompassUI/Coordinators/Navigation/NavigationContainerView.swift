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
    private let contentView: (NavigationCoordinator) -> RootViewType

    public init(@ViewBuilder contentView: @escaping (NavigationCoordinator) -> RootViewType) {
        self.contentView = contentView
    }

    public var body: some View {
        NavigationStack(path: $navigationCoordinator.path) {
            contentView(navigationCoordinator)
                .asModal()
                .navigationDestination(for: AnyNavigationRoute.self) { route in
                    route.destinationView
                }
        }
    }
}
