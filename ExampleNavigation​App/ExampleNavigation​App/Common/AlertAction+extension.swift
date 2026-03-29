//
//  AlertAction+extension.swift
//  FullNavigation
//
//  Created by Yann Bonafons on 27/03/2026.
//

import SwiftUI
import NavigationLibrary

extension AlertAction {
    static func cancel(action: ((String) -> Void)? = nil) -> AlertAction {
        AlertAction(actionMessage: "Annuler", action: action, role: .cancel)
    }
    
    static func ok(action: ((String) -> Void)? = nil) -> AlertAction {
        AlertAction(actionMessage: "Ok", action: action)
    }
}
