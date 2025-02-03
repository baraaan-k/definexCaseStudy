//
//  LoginInteractor.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation
import Combine

protocol LoginInteractorInput: AnyObject {
    func login(email: String, password: String) -> AnyPublisher<LoginResponse, Error>
}

protocol LoginInteractorOutput: AnyObject {
    func didLoginSuccessfully(token: String)
    func didFailToLogin(error: Error)
}

class LoginInteractor: LoginInteractorInput {
    
    var output: LoginInteractorOutput?
    private let apiService = APIService.shared
    private var cancellables: Set<AnyCancellable> = []
    
    func login(email: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        let parameters: [String: Any] = ["email": email, "password": password]
        
        
        return apiService.request(endpoint: "https://teamdefinex-mobile-auth-casestudy.vercel.app/login", method: "POST", parameters: parameters)
        
        
            .tryMap { response -> LoginResponse in
                if let data = response as? Data {
                    print("**** raw data: \(String(data: data, encoding: .utf8))")
                    let decoder = JSONDecoder()
                    return try decoder.decode(LoginResponse.self, from: data)
                }
                throw NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
