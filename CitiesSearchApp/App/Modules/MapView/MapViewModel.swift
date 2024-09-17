//
//  MapViewModel.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 17/09/2024.
//

import SwiftUI
import MapKit

final class MapViewModel: ObservableObject {
    @Published var region: MKCoordinateRegion
    @Published var cityName: String
    
    public init(city: CityModel) {
        self.region = MKCoordinateRegion(
            center: city.locationCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        cityName = city.name
    }
    
    // Zoom in and out methods
    func zoomIn() {
        region.span.latitudeDelta /= 2
        region.span.longitudeDelta /= 2
    }
    
    func zoomOut() {
        region.span.latitudeDelta *= 2
        region.span.longitudeDelta *= 2
    }
}
