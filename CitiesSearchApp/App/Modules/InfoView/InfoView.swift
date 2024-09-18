//
//  InfoView.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 17/09/2024.
//

import SwiftUI

struct InfoView: View {
    let city: CityModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(city.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(city.subtitle)
                .font(.body)
                .foregroundColor(.white)
        }
        .padding()
        .background(.black.opacity(0.6))
        .cornerRadius(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.indigo.opacity(0.4))
    }
}

#Preview {
    InfoView(city: .mock)
}
