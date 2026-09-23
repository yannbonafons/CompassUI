//
//  SplitContainerView.swift
//  CompassUI
//
//  Created by Yann Bonafons on 21/09/2026.
//

import SwiftUI

/// SwiftUI equivalent of `UISplitViewController`. Wraps a `NavigationSplitView` and creates
/// its own ``SplitCoordinator`` internally. Two layouts are available, mirroring the native
/// `NavigationSplitView` initializers: sidebar + detail, or sidebar + content + detail.
/// The content and detail columns automatically reflect ``SplitCoordinator/selectedContentRoute``
/// and ``SplitCoordinator/selectedDetailRoute``, falling back to their placeholder views
/// when nothing is selected.
public struct SplitContainerView<SplitRouteType: SplitRoute,
                                 SidebarViewType: View>: View {
    @State private var splitCoordinator = SplitCoordinator()
    private let sidebarView: (SplitCoordinator) -> SidebarViewType
    /// `nil` when the split view has no content column (sidebar + detail layout).
    private let contentEmptyView: (() -> AnyView)?
    private let detailEmptyView: () -> AnyView

    /// Creates a two-column split view (sidebar + detail).
    /// - Parameters:
    ///   - routeType: The ``SplitRoute`` type presented in the detail column. Only used to infer the generic type.
    ///   - sidebarView: Builds the sidebar content. Receives the ``SplitCoordinator`` so it can call ``SplitCoordinator/showDetail(_:animated:)``.
    ///   - emptyView: The placeholder shown in the detail column when no route is selected. Defaults to an empty view.
    public init(_ routeType: SplitRouteType.Type = SplitRouteType.self,
                @ViewBuilder sidebarView: @escaping (SplitCoordinator) -> SidebarViewType,
                @ViewBuilder emptyView: @escaping () -> AnyView = { AnyView(EmptyView()) }) {
        self.sidebarView = sidebarView
        self.contentEmptyView = nil
        self.detailEmptyView = emptyView
    }

    /// Creates a three-column split view (sidebar + content + detail).
    /// - Parameters:
    ///   - routeType: The ``SplitRoute`` type presented in the content and detail columns. Only used to infer the generic type.
    ///   - sidebarView: Builds the sidebar content. Receives the ``SplitCoordinator`` so it can call
    ///     ``SplitCoordinator/showContent(_:animated:)`` and ``SplitCoordinator/showDetail(_:animated:)``.
    ///   - contentEmptyView: The placeholder shown in the content column when no route is selected. Defaults to an empty view.
    ///   - detailEmptyView: The placeholder shown in the detail column when no route is selected. Defaults to an empty view.
    public init(_ routeType: SplitRouteType.Type = SplitRouteType.self,
                @ViewBuilder sidebarView: @escaping (SplitCoordinator) -> SidebarViewType,
                @ViewBuilder contentEmptyView: @escaping () -> AnyView = { AnyView(EmptyView()) },
                @ViewBuilder detailEmptyView: @escaping () -> AnyView = { AnyView(EmptyView()) }) {
        self.sidebarView = sidebarView
        self.contentEmptyView = contentEmptyView
        self.detailEmptyView = detailEmptyView
    }

    public var body: some View {
        if let contentEmptyView {
            NavigationSplitView(preferredCompactColumn: preferredCompactColumnBinding) {
                sidebarView(splitCoordinator)
            } content: {
                if let route = splitCoordinator.selectedContentRoute {
                    route.destinationView
                } else {
                    contentEmptyView()
                }
            } detail: {
                detailColumn
            }
        } else {
            NavigationSplitView(preferredCompactColumn: preferredCompactColumnBinding) {
                sidebarView(splitCoordinator)
            } detail: {
                detailColumn
            }
        }
    }

    @ViewBuilder
    private var detailColumn: some View {
        if let route = splitCoordinator.selectedDetailRoute {
            route.destinationView
        } else {
            detailEmptyView()
        }
    }

    private var preferredCompactColumnBinding: Binding<NavigationSplitViewColumn> {
        Binding(
            get: { splitCoordinator.preferredCompactColumn },
            set: { splitCoordinator.preferredCompactColumn = $0 }
        )
    }
}
