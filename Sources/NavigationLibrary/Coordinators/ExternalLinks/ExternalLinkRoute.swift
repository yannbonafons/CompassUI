//
//  ExternalLinkRoute.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 28/03/2026.
//

import Foundation

protocol ExternalLinkRoute: SheetRoute {
    static func resolve(url: URL, context: RouterContext) -> Self?
}
