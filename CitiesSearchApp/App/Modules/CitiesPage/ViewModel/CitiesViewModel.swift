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
    @Published  var state: LoadingState = .loading
    
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
        
        let filteredCities = cities
            .filter { city in
                let nameMatches = searchTextLowercased.isEmpty || city.name.lowercased().hasPrefix(searchTextLowercased)
                let favoriteMatches = !showFavoritesOnly || city.isFavorite
                return nameMatches && favoriteMatches
            }
        
        return filteredCities.sorted {
            let nameComparison = $0.name.lowercased().compare($1.name.lowercased())
            return nameComparison == .orderedSame
            ? $0.country.lowercased() < $1.country.lowercased()
            : nameComparison == .orderedAscending
        }
    }
    
    func toggleFavorite(for city: CityModel) {
        manager.updateFavoriteStatus(for: city)
        
        // Update local city model
        if let index = cities.firstIndex(where: { $0.id == city.id }) {
            cities[index].isFavorite = !city.isFavorite
        }
    }

    
    @MainActor
    func loadData() async {
        do {
            cities = try await manager.loadCities()
            state = .loaded
        } catch APIError.noInternetConnection {
            state = .failed(errorTitle: "Oops! No internet connection")
        } catch {
            state = .failed(errorTitle: "Something went wrong!")
        }
    }
}
