//
//  MapView.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 17/09/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject var viewModel: MapViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            map
            buttons
        }
    }
    
    private var map: some View {
        Map(position: .constant(.region(viewModel.region))) {
            Annotation(viewModel.cityName, coordinate: viewModel.region.center) {
                ZStack {
                    Circle()
                        .foregroundStyle(.blue.opacity(0.5))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "building.2")
                        .symbolEffect(.variableColor)
                        .padding()
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(Circle())
                }
            }
        }
    }
    
    private var buttons: some View {
        VStack {
            HStack(spacing: 10) {
                Button(action: viewModel.zoomOut) {
                    Image(systemName: "minus.magnifyingglass")
                        .font(.title2)
                        .padding(10)
                        .background(.white.opacity(0.8))
                        .clipShape(Circle())
                }
                
                Button(action: viewModel.zoomIn) {
                    Image(systemName: "plus.magnifyingglass")
                        .font(.title2)
                        .padding(10)
                        .background(.white.opacity(0.8))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            .shadow(radius: 4)
        }
    }
}

#Preview {
    MapView(viewModel: .init(city: .mock))
}
