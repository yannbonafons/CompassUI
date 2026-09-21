//
//  AnimatedCoordinator.swift
//  CompassUI
//
//  Created by Yann Bonafons on 27/03/2026.
//

import SwiftUI

/// Provides ``execute(animated:action:)`` so coordinators can optionally disable
/// animations around a state mutation via `withTransaction`.
protocol AnimatedCoordinator {}

extension AnimatedCoordinator {
    /// Runs `action`, disabling animations via `withTransaction` when `animated` is `false`.
    func execute(animated: Bool = true,
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
