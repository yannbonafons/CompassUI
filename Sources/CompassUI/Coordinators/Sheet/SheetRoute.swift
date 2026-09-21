//
//  SheetRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI

/// Define an enum case per sheet destination. Override ``configuration``
/// to customize presentation detents (defaults to `.large`).
public protocol SheetRoute: Route {
    var configuration: SheetConfiguration { get }
}

extension SheetRoute {
    public var configuration: SheetConfiguration {
        SheetConfiguration()
    }
}

public struct AnySheetRoute: @MainActor AnyRoute {
    public let id: AnyHashable
    let configuration: SheetConfiguration
    let destinationView: AnyView
}

extension SheetRoute {
    func erased() -> AnySheetRoute {
        AnySheetRoute(
            id: AnyHashable(self),
            configuration: configuration,
            destinationView: AnyView(destinationView)
        )
    }
}
