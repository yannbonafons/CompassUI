//
//  SheetConfiguration.swift
//  CompassUI
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI

/// Presentation configuration for a ``SheetRoute``, controlling its `presentationDetents`.
public struct SheetConfiguration {
    let detents: Set<PresentationDetent>
    let showsCloseButton: Bool

    /// - Parameters:
    ///   - detents: The detents allowed for the sheet. Defaults to `[.large]`.
    ///   - showsCloseButton: Whether a cancellation toolbar button is added to dismiss the sheet. Defaults to `true`.
    public init(detents: Set<PresentationDetent> = [.large],
                showsCloseButton: Bool = true) {
        self.detents = detents
        self.showsCloseButton = showsCloseButton
    }
}

extension SheetConfiguration: Equatable {
    public static func == (lhs: SheetConfiguration, rhs: SheetConfiguration) -> Bool {
        lhs.detents == rhs.detents && lhs.showsCloseButton == rhs.showsCloseButton
    }
}
