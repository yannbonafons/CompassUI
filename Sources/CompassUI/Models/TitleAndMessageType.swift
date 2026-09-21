//
//  TitleAndMessageType.swift
//  CompassUI
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

/// The title and/or message displayed by an alert presented via ``AlertCoordinator``.
public enum TitleAndMessageType {
    case message(message: LocalizedStringResource)
    case title(title: LocalizedStringResource)
    case messageAndTitle(message: LocalizedStringResource, title: LocalizedStringResource)

    /// The message component, or `nil` if this case carries no message.
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

    /// The title component, or `nil` if this case carries no title.
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
