//
//  DiscoverInteractor.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation
import Combine

protocol DiscoverInteractorInput: AnyObject {
    func getFirst() -> AnyPublisher<DiscoverResponse, Error>?
    func getSecond() -> AnyPublisher<DiscoverResponse, Error>?
    func getThird() -> AnyPublisher<DiscoverResponse, Error>?
    
    
}

protocol DiscoverInteractorOutput: AnyObject {
    func didFetchFirstList(_ products: [DiscoverListResponse])
    func didFetchSecondList(_ products: [DiscoverListResponse])
    func didFetchThirdList(_ products: [DiscoverListResponse])
    func didFailToFetch(error: Error)
}

class DiscoverInteractor: DiscoverInteractorInput {
    var output: DiscoverInteractorOutput?
    private let apiService = APIService.shared
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        
        NetworkManager.shared.observeNetworkConnection()
            .sink { [weak self] isConnected in
                
                self?.handleNetworkConnectionChanged(isConnected)
            }
            .store(in: &cancellables)
    }
    
    func networkCheck() -> Bool {
        if !NetworkManager.shared.checkInternetConnection() {
            return true
        } else {
            return false
        }
        
    }
    
    func getFirst() -> AnyPublisher<DiscoverResponse, Error>? {
        if networkCheck() {
            if let cachedProducts = CacheManager.shared.loadCachedList(key: CacheManager.firstListKey) {
                output?.didFetchFirstList(cachedProducts)
            } else {
                output?.didFailToFetch(error: NSError(domain: "NoInternet", code: -1, userInfo: nil))
            }
            return nil
        } else {
            return apiService.request(endpoint: "https://teamdefinex-mobile-auth-casestudy.vercel.app/discoverFirstHorizontalList", method: "GET")
                .tryMap { response -> DiscoverResponse in
                    if let data = response as? Data {
                        
                        let decoder = JSONDecoder()
                        return try decoder.decode(DiscoverResponse.self, from: data)
                    }
                    throw NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        
        
    }
    
    func getSecond() -> AnyPublisher<DiscoverResponse, Error>? {
        if networkCheck() {
            if let cachedProducts = CacheManager.shared.loadCachedList(key: CacheManager.secondListKey) {
                output?.didFetchSecondList(cachedProducts)
            } else {
                output?.didFailToFetch(error: NSError(domain: "NoInternet", code: -1, userInfo: nil))
            }
            return nil
        } else {
            return apiService.request(endpoint: "https://teamdefinex-mobile-auth-casestudy.vercel.app/discoverSecondHorizontalList", method: "GET")
                .tryMap { response -> DiscoverResponse in
                    if let data = response as? Data {
                        
                        let decoder = JSONDecoder()
                        return try decoder.decode(DiscoverResponse.self, from: data)
                    }
                    throw NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            
        }
        
    }
    
    func getThird() -> AnyPublisher<DiscoverResponse, Error>? {
        if networkCheck() {
            if let cachedProducts = CacheManager.shared.loadCachedList(key: CacheManager.thirdListKey) {
                output?.didFetchThirdList(cachedProducts)
            } else {
                output?.didFailToFetch(error: NSError(domain: "NoInternet", code: -1, userInfo: nil))
            }
            return nil
        } else {
            return apiService.request(endpoint: "https://teamdefinex-mobile-auth-casestudy.vercel.app/discoverThirthTwoColumnList", method: "GET")
                .tryMap { response -> DiscoverResponse in
                    if let data = response as? Data {
                        
                        let decoder = JSONDecoder()
                        return try decoder.decode(DiscoverResponse.self, from: data)
                    }
                    throw NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        
    }
    
    private func handleNetworkConnectionChanged(_ isConnected: Bool) {
        
        if isConnected {
            print("connecteddddddd")
            
        } else {
            
            print("İnternet bağlantısı kesildi.")
        }
    }
}
