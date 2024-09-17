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

    var state: LoadingState = .loading
    private var service: APIManager
    private var cancellables = Set<AnyCancellable>()

    init(service: APIManager = DefaultAPIManager.shared) {
        self.service = service
        addSubscribers()
    }
    
    private func addSubscribers() {
        $searchText
            .combineLatest($cities)
            .map(filterCities)
            .sink { [weak self] filteredCities in
                self?.filteredCities = filteredCities
            }
            .store(in: &cancellables)
    }
    
    private func filterCities(searchText: String, cities: [CityModel]) -> [CityModel] {
        guard !searchText.isEmpty else {
            return cities
        }
        
        return cities.filter { $0.name.lowercased().hasPrefix(searchText.lowercased()) }
    }
    
    @MainActor
    func loadData() async {
        defer {
            state = .loaded
        }
        
        do {
            cities = try await service.performGetRequest(endpoint: .cities)
        } catch APIError.noInternetConnection {
            state = .failed(errorTitle: "Oops! No internet connection")
        } catch {
            state = .failed(errorTitle: "Something went wrong!")
        }
    }
}
