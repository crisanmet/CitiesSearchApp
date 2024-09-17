//
//  OnFirstAppearModifier.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 16/09/2024.
//  Source: https://holyswift.app/triggering-an-action-only-first-time-a-view-appears-in-swiftui/
//

import SwiftUI

public struct OnFirstAppearModifier: ViewModifier {
    
    private let onFirstAppearAction: () async -> Void
    @State private var hasAppeared = false
    
    public init(_ onFirstAppearAction: @escaping () async -> Void) {
        self.onFirstAppearAction = onFirstAppearAction
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                Task { @MainActor in
                    await onFirstAppearAction()
                }
            }
    }
}

public extension View {
    
    func onFirstAppear(_ onFirstAppearAction: @escaping () async -> Void) -> some View {
        return modifier(OnFirstAppearModifier(onFirstAppearAction))
    }
}
