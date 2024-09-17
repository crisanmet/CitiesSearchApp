//
//  CityModel.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 14/09/2024.
//

import Foundation
import CoreLocation

struct CityModel: Identifiable, Codable {
    let id: Int
    let country: String
    let name: String
    let coordinate: CoordinateModel
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case coordinate = "coord"
        case country, name
    }
}

struct CoordinateModel: Codable {
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

// MARK: Mocks
extension CityModel {
    static var mock: CityModel = .init(id: 1, country: "Argentina", name: "Bs As", coordinate: .init(longitude: 223434, latitude: 324242))
}

// MARK: Computed Properties
extension CityModel {
    var locationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    var title: String {
        "\(name), \(country)"
    }
    
    var subtitle: String {
        "Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)"
    }
}
