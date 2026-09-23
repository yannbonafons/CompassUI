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
    /// Alerts waiting to be shown, in the order they were queued.
    private var queuedAlertConfigurations: [AlertConfiguration] = []
    public private(set) var alertConfiguration: AlertConfiguration?

    public init() {}

    /// Queues `alertConfiguration` for presentation. Shown immediately if no alert is
    /// currently visible, otherwise displayed once the current one is dismissed.
    public func showAlert(_ alertConfiguration: AlertConfiguration) {
        if self.alertConfiguration == nil {
            self.alertConfiguration = alertConfiguration
        } else {
            queuedAlertConfigurations.append(alertConfiguration)
        }
    }

    /// Dismisses the currently visible alert. No-ops (and logs) if no alert is visible.
    public func hideAlert() {
        guard alertConfiguration != nil else {
            print("No alert")
            return
        }
        alertConfiguration = nil
        guard !queuedAlertConfigurations.isEmpty else {
            return
        }
        let next = queuedAlertConfigurations.removeFirst()
        // SwiftUI can't re-present a boolean-driven `.alert` in the same update cycle
        // it was just dismissed in — wait for the dismiss animation to finish first.
        Task {
            try? await Task.sleep(for: .milliseconds(50))
            self.alertConfiguration = next
        }
    }
}
