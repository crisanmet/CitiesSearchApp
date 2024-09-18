//
//  DefaultNavigationHandling.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 17/09/2024.
//

import UIKit
import SwiftUI

struct DefaultNavigationHandling: NavigationHandling {
    public var mainViewController: UIViewController
    
    init(mainViewController: UIViewController) {
        self.mainViewController = mainViewController
    }
    
    func pushView(_ view: some View) {
        let viewController = view.embeddedInHostingController()
        mainViewController.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentView(_ view: some View) {
        let viewController = view.embeddedInHostingController()
        viewController.modalPresentationStyle = .pageSheet
        viewController.sheetPresentationController?.detents = [.medium()]
        viewController.sheetPresentationController?.prefersGrabberVisible = true
        mainViewController.navigationController?.present(viewController, animated: true)
    }
}
