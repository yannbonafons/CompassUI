//
//  AlertCoordinator.swift
//  CompassUI
//
//  Created by Yann Bonafons on 21/03/2026.
//

import SwiftUI

/// Exposes the currently visible alert and allows dismissing it.
public protocol AlertCoordinatorProtocol: AnyObject, Observable {
    /// The alert currently presented, or `nil` if none is visible.
    var alertConfiguration: AlertConfiguration? { get }

    /// Dismisses the currently visible alert.
    func hideAlert()
}

/// Displays one alert at a time. If ``showAlert(_:)`` is called while an alert is already visible,
/// the new alert is queued and will appear once the current one is dismissed.
@Observable
public class AlertCoordinator: @MainActor HashableProtocol, AlertCoordinatorProtocol {
    var alertConfigurations: [AlertConfiguration] = []
    public var alertConfiguration: AlertConfiguration? {
        alertConfigurations.last
    }

    public init() {}

    /// Queues `alertConfiguration` for presentation. Shown immediately if no alert is
    /// currently visible, otherwise displayed once the current one is dismissed.
    public func showAlert(_ alertConfiguration: AlertConfiguration) {
        alertConfigurations.insert(alertConfiguration, at: 0)
    }

    /// Dismisses the currently visible alert. No-ops (and logs) if no alert is visible.
    public func hideAlert() {
        if !alertConfigurations.isEmpty {
            alertConfigurations.removeLast()
        } else {
            print("No sheet")
        }
    }
}
