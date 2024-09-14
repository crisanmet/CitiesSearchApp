//
//  APIManager.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 14/09/2024.
//

import Foundation
import OSLog
import Network

protocol APIManager {
    func performGetRequest<T: Decodable>(endpoint: APIEndpoint) async throws -> T
    var hasInternet: Bool { get }
}

enum APIError: Error {
    case invalidURL
    case noData
    case noInternetConnection
    case decodingError(Error)
}

enum APIEndpoint {
    case cities
    
    var path: String {
        switch self {
        case .cities:
            return "/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
        }
    }
    
    var url: URL? {
        switch self {
        case .cities:
            return URL(string: "\(Constants.Config.apiUrl)\(path)")
        }
    }
}

final class DefaultAPIManager: APIManager {
    
    static let shared = DefaultAPIManager()
    
    private let logger = Logger(subsystem: "meliDemo", category: "API")
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var monitor: NWPathMonitor
    private(set) var hasInternet: Bool = true

    private init() {
        monitor = NWPathMonitor()
        startNetworkMonitoring()
    }
    
    deinit {
        monitor.cancel()
    }
    
    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.hasInternet = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    func performGetRequest<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        guard hasInternet else {
            logger.error("No internet connection")
            throw APIError.noInternetConnection
        }
        
        guard let url = endpoint.url else {
            logger.error("Invalid URL: \(String(describing: endpoint.url))")
            throw APIError.invalidURL
        }
        
        logger.info("Performing GET request to URL: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            logger.error("Received non-200 response: \(String(describing: response))")
            throw APIError.noData
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            logger.info("Successfully decoded data")
            return decodedData
        } catch {
            logger.error("Decoding error: \(error.localizedDescription)")
            throw APIError.decodingError(error)
        }
    }
}
