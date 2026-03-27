//
//  AnimatedCoordinator.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

public protocol AnimatedCoordinator {}

extension AnimatedCoordinator {
    public func execute(animated: Bool = true,
                        action: () -> Void) {
        if animated {
            action()
        } else {
            var transaction = Transaction(animation: .none)
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                action()
            }
        }
    }
}

public protocol HashableProtocol: AnyObject, Hashable {}

extension HashableProtocol {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
