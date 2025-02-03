//
//  DiscoverRouter.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation
import UIKit

protocol DiscoverRouterInput: AnyObject {
    func navigateToHomeScreen()
}

class DiscoverRouter: DiscoverRouterInput {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToHomeScreen() {
        
    }
}
