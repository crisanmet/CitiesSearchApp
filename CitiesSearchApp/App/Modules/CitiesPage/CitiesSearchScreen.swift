//
//  CitiesSearchScreen.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 16/09/2024.
//

import SwiftUI

struct CitiesSearchScreen: View {
    @StateObject private var viewModel = CitiesViewModel()
    
    var body: some View {
        NavigationStack {
            AsyncContentView(source: viewModel) {
                ScrollView {
                    LazyVStack {
                        citiesList
                    }
                }
                .overlay {
                    if viewModel.filteredCities.isEmpty {
                        nothingFound
                    }
                }
            }
            .navigationTitle("Cities")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for cities...")
        }
        .onFirstAppear {
            Task {
                await viewModel.loadData()
            }
        }
    }
    
    
    private var citiesList: some View {
        ForEach(viewModel.filteredCities) { city in
            CityRowView(
                city: city,
                isFavorite: false, // todo
                onFavoriteToggle: {
                    // todo
                },
                onMapTap: {
                    // todo
                },
                onInfoTap: {
                    // todo
                }
            )
        }
    }
    
    private var nothingFound: some View {
        Text("Oops! Nothing found")
            .font(.headline)
            .foregroundColor(.gray)
            .padding()
    }
}

#Preview {
    CitiesSearchScreen()
}
