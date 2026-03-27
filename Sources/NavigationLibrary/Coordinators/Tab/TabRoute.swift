//
//  TabRoute.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 27/03/2026.
//

public protocol TabRoute: Hashable {}

extension TabRoute {
    public func erased() -> AnyTabRoute {
        AnyTabRoute(id: AnyHashable(self))
    }
}

public struct AnyTabRoute: Hashable {
    public let id: AnyHashable

    public init(id: AnyHashable) {
        self.id = id
    }
}
