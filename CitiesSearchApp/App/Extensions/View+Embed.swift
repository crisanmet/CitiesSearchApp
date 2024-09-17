//
//  View+Embed.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 16/09/2024.
//

import SwiftUI

extension View {
    
    func embeddedInHostingController() -> UIHostingController<some View> {
        return UIHostingController(rootView: self)
    }
}
