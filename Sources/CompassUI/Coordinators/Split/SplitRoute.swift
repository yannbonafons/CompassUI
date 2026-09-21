//
//  SplitRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 21/09/2026.
//

import SwiftUI

public protocol SplitRoute: Route {}

public struct AnySplitRoute: @MainActor AnyRoute {
    public let id: AnyHashable
    let destinationView: AnyView

    public init(id: AnyHashable, destinationView: AnyView) {
        self.id = id
        self.destinationView = destinationView
    }
}

extension SplitRoute {
    public func erased() -> AnySplitRoute {
        AnySplitRoute(
            id: AnyHashable(self),
            destinationView: AnyView(destinationView)
        )
    }
}
