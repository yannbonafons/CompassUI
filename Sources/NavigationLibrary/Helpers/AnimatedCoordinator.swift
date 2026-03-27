//
//  AnimatedCoordinator.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 27/03/2026.
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
