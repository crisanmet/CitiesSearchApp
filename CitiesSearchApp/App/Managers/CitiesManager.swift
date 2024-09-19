//
//  CitiesManager.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 18/09/2024.
//

import Foundation

struct CitiesManager {
    private let service: APIManager
    private let userDefaults = UserDefaults.standard
    
    init(service: APIManager = DefaultAPIManager.shared) {
        self.service = service
    }
    
    func loadCities() async throws -> [CityModel] {
        let loadedCities: [CityModel] = try await service.performGetRequest(endpoint: .cities)
        let favoriteCityIds = getFavoriteCityIds()
        
        // Update favorite status before returning
        return loadedCities.map { city in
            var updatedCity = city
            updatedCity.isFavorite = favoriteCityIds.contains(city.id)
            return updatedCity
        }
    }
    
    func getFavoriteCityIds() -> Set<Int> {
        let ids = userDefaults.array(forKey: Constants.UserDefaultKeys.favoriteCityIds) as? [Int] ?? []
        return Set(ids)
    }
    
    func saveFavoriteCityIds(_ ids: Set<Int>) {
        userDefaults.set(Array(ids), forKey: Constants.UserDefaultKeys.favoriteCityIds)
    }
    
    func updateFavoriteStatus(for city: CityModel) {
        var favoriteCityIds = getFavoriteCityIds()
        if city.isFavorite {
            favoriteCityIds.insert(city.id)
        } else {
            favoriteCityIds.remove(city.id)
        }
        saveFavoriteCityIds(favoriteCityIds)
    }
}
