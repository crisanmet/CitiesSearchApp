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
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case coordinate = "coord"
        case country, name
    }
}

extension CityModel: Comparable {
    static func == (lhs: CityModel, rhs: CityModel) -> Bool {
        lhs.id == rhs.id && lhs.name.lowercased() == rhs.name.lowercased()
    }
    
    static func < (lhs: CityModel, rhs: CityModel) -> Bool {
        let nameComparison = lhs.name.caseInsensitiveCompare(rhs.name)
        
        if nameComparison == .orderedSame {
            return lhs.country.caseInsensitiveCompare(rhs.country) == .orderedAscending
        }
        
        return nameComparison == .orderedAscending
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
