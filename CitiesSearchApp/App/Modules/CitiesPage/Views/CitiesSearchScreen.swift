//
//  CitiesSearchScreen.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 16/09/2024.
//

import SwiftUI

struct CitiesSearchScreen: View {
    @StateObject private var viewModel = CitiesViewModel()
    @State private var orientation = UIDeviceOrientation.portrait
    @State private var selectedCity: CityModel?
    @Environment(\.navigationHandling) var navigator
    
    var body: some View {
        AsyncContentView(source: viewModel) {
            viewForDeviceOrientation
        }     
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        .onFirstAppear {
            Task {
                await viewModel.loadData()
            }
        }
    }
    
    @ViewBuilder
    private var viewForDeviceOrientation: some View {
        if orientation.isLandscape {
            HStack {
                NavigationStack {
                    citiesListView
                }
                .frame(width: UIScreen.size.width * 0.5)
                
                mapView
                    .frame(width: UIScreen.size.width * 0.5)
            }
        } else {
            NavigationStack {
                citiesListView
            }
        }
    }
    
    private var citiesListView: some View {
        ScrollView {
            LazyVStack {
                citiesList
                    .padding(.horizontal, orientation.isPortrait ? 12 : 0)
            }
        }
        .overlay {
            if viewModel.filteredCities.isEmpty {
                nothingFound
            }
        }   
        .navigationTitle("Cities")
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for cities...")
    }
    
    @ViewBuilder
    private var mapView: some View {
        if let selectedCity {
            MapView(viewModel: .init(city: selectedCity))
                .id(selectedCity.id)
        } else if let firstCity = viewModel.filteredCities.first {
            MapView(viewModel: .init(city: firstCity))
                .id(firstCity.id)
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
                onCardTap: {
                    handleCardTapped(city)
                },
                onInfoTap: {
                    handleInfoTapped(city)
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
    
    private func handleCardTapped(_ city: CityModel) {
        if orientation.isLandscape {
            selectedCity = city
        } else {
            navigator?.pushView(MapView(viewModel: .init(city: city)))
        }
    }
    
    private func handleInfoTapped(_ city: CityModel) {
        let view = InfoView(city: city)
        if UIDevice.current.orientation.isLandscape {
            navigator?.pushView(view)
        } else {
            navigator?.presentView(view)
        }
    }
}

#Preview {
    CitiesSearchScreen()
}
