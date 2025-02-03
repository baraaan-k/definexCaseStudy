//
//  LoginRouter.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import UIKit

protocol LoginRouterInput: AnyObject {
    func navigateToHomeScreen()
}

class LoginRouter: LoginRouterInput {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToHomeScreen() {
        let router = MainRouter()
        let tabBarController = router.createTabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        self.viewController?.present(tabBarController, animated: true)
    }
}



