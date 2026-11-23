//
//  ExternalLinkModifier.swift
//  CompassUI
//
//  Created by Yann Bonafons on 28/03/2026.
//

import SwiftUI

private struct ExternalLinkModifier<RouteType: ExternalLinkRoute>: ViewModifier {
    let globalContext: RouteType.ContextType.GlobalContext
    @State private var navigationCoordinator = NavigationCoordinator()

    private var context: RouteType.ContextType {
        RouteType.ContextType(navigationCoordinator: navigationCoordinator,
                              splitCoordinator: nil,
                              globalContext: globalContext)
    }

    func body(content: Content) -> some View {
        content
            .onOpenURL { url in
                handle(url)
            }
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                guard let url = activity.webpageURL else {
                    return
                }
                handle(url)
            }
    }

    private func handle(_ url: URL) {
        guard let route = RouteType.resolve(url: url, context: context) else {
            return
        }
        globalContext.sheetCoordinator.showSheet(route)
    }
}

// MARK: - View Extension

public extension View {
    /// Handles deeplinks (`onOpenURL`) and universal links. Apply once at the root level.
    func externalLinks<RouteType: ExternalLinkRoute>(
        _ routeType: RouteType.Type,
        globalContext: RouteType.ContextType.GlobalContext
    ) -> some View {
        modifier(ExternalLinkModifier<RouteType>(globalContext: globalContext))
    }
}
