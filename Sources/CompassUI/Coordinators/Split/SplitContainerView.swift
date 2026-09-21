//
//  SplitContainerView.swift
//  CompassUI
//
//  Created by Yann Bonafons on 21/09/2026.
//

import SwiftUI

public struct SplitContainerView<SplitRouteType: SplitRoute,
                                 SidebarViewType: View>: View {
    @State private var splitCoordinator = SplitCoordinator()
    private let sidebarView: (SplitCoordinator) -> SidebarViewType
    private let emptyView: () -> AnyView

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
