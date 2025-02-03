//
//  MockData.swift
//  DefinexCaseStudyTests
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation
import Combine
@testable import DefinexCaseStudy

class MockDiscoverView: DiscoverView {
    func stopRefreshing() {
        
    }
    
    func displayError(_ message: String) {
        
    }
    
    var didCallDisplayFirstList = false
    
    func displayFirstList(_ products: [DiscoverListResponse]) {
        didCallDisplayFirstList = true
    }
    
    func displaySecondList(_ products: [DiscoverListResponse]) {}
    func displayThirdList(_ products: [DiscoverListResponse]) {}
}

class MockDiscoverInteractor: DiscoverInteractorInput {
    var mockResponse: DiscoverResponse?
    
    func getFirst() -> AnyPublisher<DiscoverResponse, Error>? {
        guard let response = mockResponse else { return nil }
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getSecond() -> AnyPublisher<DiscoverResponse, Error>? { return nil }
    func getThird() -> AnyPublisher<DiscoverResponse, Error>? { return nil }
}

class MockDiscoverRouter: DiscoverRouterInput {
    func navigateToHomeScreen() {
        
    }
}

class MockDiscoverInteractorOutput: DiscoverInteractorOutput {
    func didFetchFirstList(_ products: [DiscoverListResponse]) {}
    func didFetchSecondList(_ products: [DiscoverListResponse]) {}
    func didFetchThirdList(_ products: [DiscoverListResponse]) {}
    func didFailToFetch(error: Error) {}
}

class MockAPIService {
    func request(endpoint: String, method: String) -> AnyPublisher<Data, Error> {
        let sampleData = """
{"isSuccess": true, "message": "Transaction Successful", "statusCode": null, "list": [{"imageUrl": "https://teamdefinex-mobile-auth-casestudy.vercel.app/image/1", "description": "Little Black Book For Perfect Reading", "price": {"value": 19.99, "currency": "$"}, "oldPrice": {"value": 39.99, "currency": "$"}, "discount": "48% OFF", "ratePercentage": null}, {"imageUrl": "https://teamdefinex-mobile-auth-casestudy.vercel.app/image/2", "description": "Wrist Watch Swiss Made", "price": {"value": 19.99, "currency": "$"}, "oldPrice": {"value": 39.99, "currency": "$"}, "discount": "48% OFF", "ratePercentage": null}]}
""".data(using: .utf8)
        return Just(sampleData ?? Data())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
