//
//  TitleAndMessageType.swift
//  CompassUI
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

public enum TitleAndMessageType {
    case message(message: LocalizedStringResource)
    case title(title: LocalizedStringResource)
    case messageAndTitle(message: LocalizedStringResource, title: LocalizedStringResource)

    public var message: LocalizedStringResource? {
        switch self {
        case .message(let message):
            message
        case .title:
            nil
        case .messageAndTitle(let message, _):
            message
        }
    }

    public var title: LocalizedStringResource? {
        switch self {
        case .message:
            nil
        case .title(let title):
            title
        case .messageAndTitle(_, let title):
            title
        }
    }
}
