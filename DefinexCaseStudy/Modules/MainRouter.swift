//
//  MainRouter.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation
import UIKit

class MainRouter {
    func createTabBarController() -> UITabBarController {
        
        let tabBarController = UITabBarController()
        
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barTintColor = .white
        tabBarController.tabBar.tintColor = .darkGray
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.barTintColor = .white
        tabBarController.tabBar.shadowImage = UIImage()
        tabBarController.tabBar.backgroundImage = UIImage()
        
        
        let discoverViewController = DiscoverViewController()
        let secondViewController = ViewController()
        let thirdViewController = ViewController()
        let forthViewController = ViewController()
        let fifthViewController = ViewController()
        
        let discoverNavController = UINavigationController(rootViewController: discoverViewController)
        let secondNavController = UINavigationController(rootViewController: secondViewController)
        let thirdNavController = UINavigationController(rootViewController: thirdViewController)
        let forthNavController = UINavigationController(rootViewController: forthViewController)
        let fifthNavController = UINavigationController(rootViewController: fifthViewController)
        
        
        discoverNavController.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "bag"), selectedImage: UIImage(systemName: "bag"))
        secondNavController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book"))
        thirdNavController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "basket"), selectedImage: UIImage(systemName: "basket"))
        forthNavController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "creditcard"), selectedImage: UIImage(systemName: "creditcard"))
        fifthNavController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person"))
        
        
        tabBarController.viewControllers = [discoverNavController, secondNavController, thirdNavController, forthNavController, fifthNavController]
        
        return tabBarController
    }
}

