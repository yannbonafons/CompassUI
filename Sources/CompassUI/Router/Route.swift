//
//  Route.swift
//  CompassUI
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI

/// Base protocol for all route types. Routes must be `Hashable` (required by `NavigationPath`).
///
/// **Payload best practice**: keep routes lightweight — pass identifiers (IDs, strings, enums),
/// not full model objects. The destination view should resolve heavy data from a store/service.
/// If you must carry a non-Hashable object, implement `Hashable` on a stable identity subset (e.g., `id`).
public protocol Route: Hashable {
    associatedtype ViewType: View

    @ViewBuilder
    var destinationView: ViewType { get }
}

protocol AnyRoute: Hashable, Identifiable {
    var id: AnyHashable { get }
}

extension AnyRoute {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
