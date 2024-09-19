//
//  Helpers+Extras.swift
//  CitiesSearchAppTests
//
//  Created by Cristian Sancricca on 19/09/2024.
//

import Foundation

private class TestHelper { } // To get correct bundle.

func loadJSONFromBundle<T: Decodable>(_ filename: String) -> T {
    let data: Data
    let bundle = Bundle(for: TestHelper.self)
    
    guard let filePath = bundle.path(forResource: filename, ofType: "json") else {
        fatalError("Couldnt find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: URL(fileURLWithPath: filePath))
    } catch {
        fatalError("Couldnt load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Couldtt parse \(filename) as \(T.self):\n\(error)")
    }
}
