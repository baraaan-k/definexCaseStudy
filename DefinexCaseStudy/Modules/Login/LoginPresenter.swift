//
//  LoginPresenter.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation
import Combine


protocol LoginPresenterInput: AnyObject {
    func login(email: String, password: String)
}


class LoginPresenter: LoginPresenterInput, LoginInteractorOutput {
    
    weak var view: LoginView?
    var interactor: LoginInteractorInput?
    var router: LoginRouterInput?
    private var cancellables: Set<AnyCancellable> = []
    
    init(view: LoginView, interactor: LoginInteractorInput, router: LoginRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    
    func login(email: String, password: String) {
        
        interactor?.login(email: email, password: password)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.view?.showLoginError(error.localizedDescription)
                }
            }, receiveValue: { [weak self] loginResponse in
                if loginResponse.isSuccess == true {
                    self?.handleSuccessfulLogin(token: loginResponse.token)
                }
                
            })
            .store(in: &cancellables)
    }
    
    private func handleSuccessfulLogin(token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
        router?.navigateToHomeScreen()
    }
    
    
    func didLoginSuccessfully(token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
        router?.navigateToHomeScreen()
    }
    
    func didFailToLogin(error: Error) {
        view?.showLoginError(error.localizedDescription)
    }
    
    
}
