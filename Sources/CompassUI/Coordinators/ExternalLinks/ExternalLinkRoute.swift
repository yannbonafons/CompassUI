//
//  ExternalLinkRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 28/03/2026.
//

import Foundation

/// Conform to handle deeplinks and universal links. ``resolve(url:context:)`` returns
/// `nil` for unmatched URLs; matched routes are automatically presented as sheets.
public protocol ExternalLinkRoute: SheetRoute {
    /// The context handed to ``resolve(url:context:)``. Defaults to ``RouterContext``;
    /// use ``RouterContextLite`` for an app without tab bar.
    associatedtype ContextType: RouterContextProtocol = RouterContext

    static func resolve(url: URL, context: ContextType) -> Self?
}
