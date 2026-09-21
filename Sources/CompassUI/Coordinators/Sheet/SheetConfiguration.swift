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

    /// - Parameter detents: The detents allowed for the sheet. Defaults to `[.large]`.
    public init(detents: Set<PresentationDetent> = [.large]) {
        self.detents = detents
    }
}

extension SheetConfiguration: Equatable {
    public static func == (lhs: SheetConfiguration, rhs: SheetConfiguration) -> Bool {
        lhs.detents == rhs.detents
    }
}
