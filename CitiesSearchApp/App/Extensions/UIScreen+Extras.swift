//
//  UIScreen+Extras.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 18/09/2024.
//

import UIKit

extension UIScreen {
    static var size: CGRect {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return CGRect()
        }
        
        return window.screen.bounds
    }
}
