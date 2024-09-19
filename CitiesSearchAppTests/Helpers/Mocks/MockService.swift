//
//  MockService.swift
//  CitiesSearchAppTests
//
//  Created by Cristian Sancricca on 19/09/2024.
//

import Foundation
@testable import CitiesSearchApp

final class MockService: APIManager {
    var mockData: [CityModel]?
    var hasInternet: Bool
    
    init(mockData: [CityModel]?, hasInternet: Bool = true) {
        self.mockData = mockData
        self.hasInternet = hasInternet
    }
    
    func performGetRequest<T: Decodable>(endpoint: CitiesSearchApp.APIEndpoint) async throws -> T {
        guard hasInternet else {
            throw APIError.noInternetConnection
        }
        
        if let mockData = mockData as? T {
            return mockData
        } else {
            throw APIError.noData
        }
    }
}
