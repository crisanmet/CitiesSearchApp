//
//  CitiesViewModel.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 16/09/2024.
//

import Foundation
import Combine

final class CitiesViewModel: Loadable {
    @Published var cities: [CityModel] = []
    @Published var searchText: String = ""
    @Published var filteredCities: [CityModel] = []
    @Published var showFavoritesOnly: Bool = false

    var state: LoadingState = .loading
    private var manager: CitiesManager
    private var cancellables = Set<AnyCancellable>()
    
    init(manager: CitiesManager = CitiesManager()) {
        self.manager = manager
        addSubscribers()
    }
    
    private func addSubscribers() {
        $searchText
            .combineLatest($cities, $showFavoritesOnly)
            .map(filterCities)
            .sink { [weak self] filteredCities in
                self?.filteredCities = filteredCities
            }
            .store(in: &cancellables)
    }
    
    private func filterCities(searchText: String, cities: [CityModel], showFavoritesOnly: Bool) -> [CityModel] {
        let searchTextLowercased = searchText.lowercased()
        
        return cities.filter { city in
            let matchesSearchText = searchTextLowercased.isEmpty || city.name.lowercased().hasPrefix(searchTextLowercased)
            let matchesFavoriteStatus = !showFavoritesOnly || city.isFavorite
            return matchesSearchText && matchesFavoriteStatus
        }  
    }
    
    func toggleFavorite(for city: CityModel) {
        let isFavorite = !city.isFavorite
        manager.updateFavoriteStatus(for: city, isFavorite: isFavorite)
        
        // Update local city model
        if let index = cities.firstIndex(where: { $0.id == city.id }) {
            cities[index].isFavorite = isFavorite
        }
    }

    
    @MainActor
    func loadData() async {
        defer {
            state = .loaded
        }
        
        do {
            cities = try await manager.loadCities()
        } catch APIError.noInternetConnection {
            state = .failed(errorTitle: "Oops! No internet connection")
        } catch {
            state = .failed(errorTitle: "Something went wrong!")
        }
    }
}
