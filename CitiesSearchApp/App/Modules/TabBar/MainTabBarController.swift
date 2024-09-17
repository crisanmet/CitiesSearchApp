//
//  MainTabBarController.swift
//  CitiesSearchApp
//
//  Created by Cristian Sancricca on 16/09/2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupTabs()
    }
    
    private func setupTabs() {
        let citiesView = CitiesSearchScreen()
            .environment(\.navigationHandling, DefaultNavigationHandling(mainViewController: self))
        
        let favouritesView = FavouritesScreen()
            .environment(\.navigationHandling, DefaultNavigationHandling(mainViewController: self))
        
        let citiesSearchVC = citiesView.embeddedInHostingController()
        let favouritesVC = favouritesView.embeddedInHostingController()
        
        citiesSearchVC.tabBarItem.image = UIImage(systemName: "house")
        favouritesVC.tabBarItem.image = UIImage(systemName: "heart")
        
        citiesSearchVC.title = "Cities"
        favouritesVC.title = "Favoritos"
        
        setViewControllers([citiesSearchVC, favouritesVC], animated: true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupAppearance() {
        view.backgroundColor = .white
        tabBar.tintColor = .blue
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
}
