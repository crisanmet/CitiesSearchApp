//
//  CityModel.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 14/09/2024.
//

import Foundation

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
