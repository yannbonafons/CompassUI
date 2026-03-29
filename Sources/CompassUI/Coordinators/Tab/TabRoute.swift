//
//  TabRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 27/03/2026.
//

/// Conform your tab enum to this protocol. Use `erased()` to get the type-erased
/// value expected by `TabView(selection:)` and ``TabCoordinator``.
public protocol TabRoute: Hashable {}

extension TabRoute {
    public func erased() -> AnyTabRoute {
        AnyTabRoute(id: AnyHashable(self))
    }
}

public struct AnyTabRoute: Hashable {
    let id: AnyHashable

    public init(id: AnyHashable) {
        self.id = id
    }
}
