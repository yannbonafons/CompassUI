//
//  SplitCoordinator.swift
//  CompassUI
//
//  Created by Yann Bonafons on 21/09/2026.
//

import SwiftUI

@Observable
public final class SplitCoordinator: AnimatedCoordinator, @MainActor HashableProtocol {
    public private(set) var selectedRoute: AnySplitRoute?

    public init() {}

    public func show<RouteType: SplitRoute>(_ route: RouteType, animated: Bool = false) {
        execute(animated: animated) {
            selectedRoute = route.erased()
        }
    }

    public func dismissDetail(animated: Bool = false) {
        execute(animated: animated) {
            selectedRoute = nil
        }
    }
}
