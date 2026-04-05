//
//  HashableProtocol.swift
//  CompassUI
//
//  Created by Yann Bonafons on 27/03/2026.
//

import SwiftUI

protocol HashableProtocol: AnyObject, Hashable {}

extension HashableProtocol {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
