//
//  APIService.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation
import Combine


class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    
    func request(endpoint: String, method: String, parameters: [String: Any]? = nil) -> AnyPublisher<Data, Error> {
        
        guard let url = URL(string: endpoint) else {
            return Fail(error: NSError(domain: "InvalidURL", code: 0, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userDefaults = UserDefaults.standard
        if let authToken = userDefaults.string(forKey: "authToken") {
            request.addValue(authToken, forHTTPHeaderField: "token")
        }
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .mapError { $0 as URLError }
            .eraseToAnyPublisher()
    }
}


