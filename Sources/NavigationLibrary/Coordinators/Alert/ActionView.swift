//
//  ActionView.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

struct ActionView: View {
    let actionInfo: ActionInfo

    init(actionInfo: ActionInfo) {
        self.actionInfo = actionInfo
    }

    var body: some View {
        switch actionInfo {
        case .text(let localizedStringResource):
            Text(localizedStringResource)
        case .image(let imageName):
            Image(systemName: imageName)
        case .imageAndText(let imageName, let localizedStringResource):
            Label(title: {
                Text(localizedStringResource)
            }, icon: {
                Image(systemName: imageName)
            })
        }
    }
}
