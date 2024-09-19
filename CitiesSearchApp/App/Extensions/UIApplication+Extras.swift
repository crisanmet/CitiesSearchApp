//
//  UIApplication+Extras.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 19/09/2024.
//

import UIKit

extension UIApplication {
    func endEditing() {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
