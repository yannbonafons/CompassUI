//
//  BuilderProtocol.swift
//  CompassUI
//
//  Created by Yann Bonafons on 15/03/2026.
//

import SwiftUI

protocol BuilderProtocol<PayloadType> where PayloadType.BuilderType == Self {
    associatedtype PayloadType: PayloadProtocol
    associatedtype ContentView: View
    
    static func createView(with payload: PayloadType) -> ContentView
}

protocol PayloadProtocol<BuilderType>: Hashable where BuilderType.PayloadType == Self {
    associatedtype BuilderType: BuilderProtocol
}
