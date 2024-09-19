//
//  CitiesSearchViewModelTest.swift
//  CitiesSearchAppTests
//
//  Created by Cristian Sancricca on 19/09/2024.
//

import XCTest
@testable import CitiesSearchApp

final class CitiesSearchViewModelTest: XCTestCase {

    override func setUpWithError() throws {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.favoriteCityIds)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private func createSUT(withMockData mockData: [CityModel]? = nil, hasInternet: Bool = true) -> CitiesViewModel {
        let mockService = MockService(mockData: mockData, hasInternet: hasInternet)
        let citiesManager = CitiesManager(service: mockService)
        return CitiesViewModel(manager: citiesManager)
    }

    func testInitialization() {
        let sut = CitiesViewModel()
        
        XCTAssertTrue(sut.cities.isEmpty)
        XCTAssertEqual(sut.searchText, "")
        XCTAssertTrue(sut.filteredCities.isEmpty)
        XCTAssertFalse(sut.showFavoritesOnly)
        XCTAssertEqual(sut.state, .loading)
    }
    
    func testLoadCitiesSuccess() async {
        let mockData: [CityModel] = loadJSONFromBundle("mockCitiesResponse")
        let sut = createSUT(withMockData: mockData)
        
        await sut.loadData()
        XCTAssertEqual(sut.filteredCities.count, mockData.count)
        XCTAssertEqual(sut.state, .loaded)
    }
    
    func testLoadCitiesFailWithNullResponse() async {
        let sut = createSUT(withMockData: nil)
        
        await sut.loadData()
        XCTAssertEqual(sut.filteredCities.count, 0)
        XCTAssertEqual(sut.state, .failed(errorTitle: "Something went wrong!"))
    }
    
    func testLoadCitiesFailWithNoInternet() async {
        let mockData: [CityModel] = loadJSONFromBundle("mockCitiesResponse")
        let sut = createSUT(withMockData: mockData, hasInternet: false)
        
        await sut.loadData()
        XCTAssertEqual(sut.filteredCities.count, 0)
        XCTAssertEqual(sut.state, .failed(errorTitle: "Oops! No internet connection"))
    }
    
    func testToggleFavorite() async {
        let mockData: [CityModel] = loadJSONFromBundle("mockCitiesResponse")
        let sut = createSUT(withMockData: mockData)
        
        await sut.loadData()
        XCTAssertTrue(sut.state == .loaded)
        
        let cityToToggle = mockData.last ?? .mock
        sut.showFavoritesOnly = true
        sut.toggleFavorite(for: cityToToggle)
        
        XCTAssertTrue(sut.filteredCities.first { $0.id == cityToToggle.id }?.isFavorite == true)
        XCTAssertEqual(sut.filteredCities.count, 1)
    }
    
    func testPersistFavorites() async {
        UserDefaults.standard.set([707860, 1283378], forKey: Constants.UserDefaultKeys.favoriteCityIds)
        
        let mockData: [CityModel] = loadJSONFromBundle("mockCitiesResponse")
        let sut = createSUT(withMockData: mockData)
        
        await sut.loadData()
        sut.showFavoritesOnly = true
        XCTAssertEqual(sut.filteredCities.count, 2)
    }
    
    func testFilteringCities() async {
        let mockData: [CityModel] = loadJSONFromBundle("mockCitiesResponse")
        let sut = createSUT(withMockData: mockData)
        
        await sut.loadData()
        sut.searchText = "H"
        XCTAssertEqual(sut.filteredCities.first?.name, "Hurzuf")
        XCTAssertEqual(sut.filteredCities.count, 2)
        
        sut.searchText = "hu" // case sensitive
        XCTAssertEqual(sut.filteredCities.first?.name, "Hurzuf")
        XCTAssertNotEqual(sut.filteredCities.count, 2)
        XCTAssertEqual(sut.filteredCities.count, 1)
    }
}
