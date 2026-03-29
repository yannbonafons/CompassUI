//
//  Route.swift
//  CompassUI
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI

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
