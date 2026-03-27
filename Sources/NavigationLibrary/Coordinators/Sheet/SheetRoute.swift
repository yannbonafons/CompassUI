//
//  SheetRoute.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI

public protocol SheetRoute: Route {
    var configuration: SheetConfiguration { get }
}

extension SheetRoute {
    public var configuration: SheetConfiguration {
        SheetConfiguration()
    }
}

public struct AnySheetRoute: AnyRoute {
    public let id: AnyHashable
    public let configuration: SheetConfiguration
    public let destinationView: AnyView

    public init(id: AnyHashable, configuration: SheetConfiguration, destinationView: AnyView) {
        self.id = id
        self.configuration = configuration
        self.destinationView = destinationView
    }
}

extension SheetRoute {
    public func erased() -> AnySheetRoute {
        AnySheetRoute(
            id: AnyHashable(self),
            configuration: configuration,
            destinationView: AnyView(destinationView)
        )
    }
}
