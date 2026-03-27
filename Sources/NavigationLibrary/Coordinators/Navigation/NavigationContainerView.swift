//
//  NavigationContainerView.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI

public struct NavigationContainerView<RootViewType: View>: View {
    @State private var navigationCoordinator = NavigationCoordinator()
    private let sheetCoordinator: SheetCoordinator
    private let alertCoordinator: AlertCoordinator
    private let tabCoordinator: TabCoordinator
    private let contentView: (RouterContext) -> RootViewType

    private var routerContext: RouterContext {
        RouterContext(
            navigationCoordinator: navigationCoordinator,
            sheetCoordinator: sheetCoordinator,
            alertCoordinator: alertCoordinator,
            tabCoordinator: tabCoordinator
        )
    }

    public init(sheetCoordinator: SheetCoordinator,
                alertCoordinator: AlertCoordinator,
                tabCoordinator: TabCoordinator,
                @ViewBuilder contentView: @escaping (RouterContext) -> RootViewType) {
        self.sheetCoordinator = sheetCoordinator
        self.alertCoordinator = alertCoordinator
        self.tabCoordinator = tabCoordinator
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
