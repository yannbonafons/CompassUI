//
//  SheetConfiguration.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI

public struct SheetConfiguration {
    let detents: Set<PresentationDetent>

    public init(detents: Set<PresentationDetent> = [.large]) {
        self.detents = detents
    }
}

extension SheetConfiguration: Equatable {
    public static func == (lhs: SheetConfiguration, rhs: SheetConfiguration) -> Bool {
        lhs.detents == rhs.detents
    }
}
