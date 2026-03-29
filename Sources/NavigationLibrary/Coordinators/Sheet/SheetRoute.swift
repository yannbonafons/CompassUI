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

/// Use this empty route to qualify a Router without any sheet navigation
public struct EmptySheetRoute: SheetRoute {
    public var destinationView: EmptyView {
        EmptyView()
    }
}

public struct AnySheetRoute: AnyRoute {
    public let id: AnyHashable
    let configuration: SheetConfiguration
    let destinationView: AnyView

    init(id: AnyHashable, configuration: SheetConfiguration, destinationView: AnyView) {
        self.id = id
        self.configuration = configuration
        self.destinationView = destinationView
    }
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
