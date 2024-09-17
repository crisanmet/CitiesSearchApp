//
//  NavigationHandling.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 17/09/2024.
//

import SwiftUI

public protocol NavigationHandling {
    var mainViewController: UIViewController { get set }
    func pushView(_ view: some View)
    func presentView(_ view: some View)
}

private struct NavigationHandlingEnvironmentKey: EnvironmentKey {
    static let defaultValue: NavigationHandling? = nil
}

public extension EnvironmentValues {
    
    var navigationHandling: NavigationHandling? {
        get { self[NavigationHandlingEnvironmentKey.self] }
        set { self[NavigationHandlingEnvironmentKey.self] = newValue }
    }
}
