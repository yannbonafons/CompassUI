//
//  ActionInfo.swift
//  CompassUI
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

enum ActionInfo {
    case text(LocalizedStringResource)
    case image(String)
    case imageAndText(String, LocalizedStringResource)

    var text: LocalizedStringResource? {
        switch self {
        case .text(let value):
            return value
        case .image:
            return nil
        case .imageAndText(_, let value):
            return value
        }
    }

    var imageName: String? {
        switch self {
        case .text:
            return nil
        case .image(let value):
            return value
        case .imageAndText(let value, _):
            return value
        }
    }
}
