//
//  HashableProtocol.swift
//  CompassUI
//
//  Created by Yann Bonafons on 27/03/2026.
//

import SwiftUI

/// Provides identity-based (`ObjectIdentifier`) `Equatable`/`Hashable` conformance for
/// reference-type coordinators, so two distinct instances are never considered equal.
protocol HashableProtocol: AnyObject, Hashable {}

extension HashableProtocol {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
