//
//  CustomAlertModifier.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

private struct CustomAlertModifier<CoordinatorType: AlertCoordinatorProtocol>: ViewModifier {
    @Bindable var coordinator: CoordinatorType
    @State var text: String = ""

    func body(content: Content) -> some View {
        if let conf = coordinator.alertConfiguration {
            content
                .alert(conf.titleAndMessageType.title ?? "",
                       isPresented: .constant(true),
                       actions: {
                    if let confgurationTextFieldInfo = conf.textFieldInfo {
                        TextField(String(localized: confgurationTextFieldInfo.placeholder),
                                  text: $text)
                        .keyboardType(confgurationTextFieldInfo.keyboardType)
                    }
                    ForEach(conf.actions) { action in
                        Button(role: action.role,
                               action: {
                            action.action?(text)
                            coordinator.hideAlert()
                            text = ""
                        },
                               label: {
                            ActionView(actionInfo: .text(action.actionMessage))
                        })
                    }
                }, message: {
                    if let message = conf.titleAndMessageType.message {
                        Text(message)
                    }
                })
        } else {
            content
        }
    }
}

extension View {
    public func alert<CoordinatorType: AlertCoordinatorProtocol>(coordinator: CoordinatorType) -> some View {
        modifier(CustomAlertModifier(coordinator: coordinator))
    }
}
