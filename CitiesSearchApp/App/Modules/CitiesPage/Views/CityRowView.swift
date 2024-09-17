//
//  CityRowView.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 16/09/2024.
//

import SwiftUI

struct CityRowView: View {
    let city: CityModel
    @State var isFavorite: Bool
    let onFavoriteToggle: () -> Void
    let onCardTap: () -> Void
    let onInfoTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(city.title)
                    .font(.headline)
                Text(city.subtitle)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Button(action: {
                isFavorite.toggle()
                onFavoriteToggle()
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
            }
            
            Button(action: {
                onInfoTap()
            }) {
                Text("View more info")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            onCardTap()
        }
    }
}

#Preview {
    CityRowView(city: .mock, isFavorite: true, onFavoriteToggle: { }, onCardTap: { }, onInfoTap: { })
}
