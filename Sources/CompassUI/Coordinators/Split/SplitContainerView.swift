//
//  SplitContainerView.swift
//  CompassUI
//
//  Created by Yann Bonafons on 21/09/2026.
//

import SwiftUI

/// SwiftUI equivalent of `UISplitViewController`. Wraps a `NavigationSplitView` and creates
/// its own ``SplitCoordinator`` internally. The detail column automatically reflects
/// ``SplitCoordinator/selectedRoute``, falling back to `emptyView` when nothing is selected.
public struct SplitContainerView<SplitRouteType: SplitRoute,
                                 SidebarViewType: View>: View {
    @State private var splitCoordinator = SplitCoordinator()
    private let sidebarView: (SplitCoordinator) -> SidebarViewType
    private let emptyView: () -> AnyView

    /// - Parameters:
    ///   - routeType: The ``SplitRoute`` type presented in the detail column. Only used to infer the generic type.
    ///   - sidebarView: Builds the sidebar content. Receives the ``SplitCoordinator`` so it can call ``SplitCoordinator/show(_:animated:)``.
    ///   - emptyView: The placeholder shown in the detail column when no route is selected. Defaults to an empty view.
    public init(_ routeType: SplitRouteType.Type = SplitRouteType.self,
                @ViewBuilder sidebarView: @escaping (SplitCoordinator) -> SidebarViewType,
                @ViewBuilder emptyView: @escaping () -> AnyView = { AnyView(EmptyView()) }) {
        self.sidebarView = sidebarView
        self.emptyView = emptyView
    }

    public var body: some View {
        NavigationSplitView {
            sidebarView(splitCoordinator)
        } detail: {
            if let route = splitCoordinator.selectedRoute {
                route.destinationView
            } else {
                emptyView()
            }
        }
    }
}
