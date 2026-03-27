//
//  AlertCoordinator.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 21/03/2026.
//

import SwiftUI

public protocol AlertCoordinatorProtocol: AnyObject, Observable {
    var alertConfiguration: AlertConfiguration? { get }

    func hideAlert()
}

@Observable
public class AlertCoordinator: HashableProtocol, AlertCoordinatorProtocol {
    public var alertConfigurations: [AlertConfiguration] = []
    public var alertConfiguration: AlertConfiguration? {
        alertConfigurations.last
    }

    public init() {}

    public func showAlert(_ alertConfiguration: AlertConfiguration) {
        alertConfigurations.insert(alertConfiguration, at: 0)
    }

    public func hideAlert() {
        if !alertConfigurations.isEmpty {
            alertConfigurations.removeLast()
        } else {
            print("No sheet")
        }
    }
}
