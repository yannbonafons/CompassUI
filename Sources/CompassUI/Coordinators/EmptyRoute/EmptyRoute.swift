//
//  EmptyRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 21/09/2026.
//

import SwiftUI

/// Use this empty route to qualify a Router without any navigation / sheet / split
public struct EmptyRoute: @MainActor SheetRoute, @MainActor NavigationRoute, @MainActor SplitRoute {
    public var destinationView: EmptyView {
        EmptyView()
    }
}
