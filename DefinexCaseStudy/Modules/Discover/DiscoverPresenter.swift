//
//  DiscoverPresenter.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation
import Combine

protocol DiscoverPresenterInput: AnyObject {
    func fetchFirst()
    func fetchSecond()
    func fetchThird()
}

protocol DiscoverPresenterOutput: AnyObject {
    
}

class DiscoverPresenter: DiscoverPresenterInput {
    func didFetchSuccessfully(_ products: [DiscoverListResponse]) {
        
    }
    
    weak var view: DiscoverView?
    var interactor: DiscoverInteractorInput?
    var router: DiscoverRouterInput?
    private var cancellables: Set<AnyCancellable> = []
    
    init(view: DiscoverView? = nil, interactor: DiscoverInteractorInput? = nil, router: DiscoverRouterInput? = nil) {
        self.view = view
        self.interactor = interactor
        self.router = router
        if let interactor = interactor as? DiscoverInteractor {
            interactor.output = self
        }
    }
    
    func fetchFirst() {
        
        interactor?.getFirst()?
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    print("Finished")
                }
            }, receiveValue: { [weak self] response in
                self?.view?.displayFirstList(response.list)
                CacheManager.shared.saveListToCache(products: response.list, key: CacheManager.firstListKey)
            })
            .store(in: &cancellables)
    }
    
    func didFetchSuccessfully(token: String) {
        print("fetch successfully")
    }
    
    func didFailToFetch(error: any Error) {
        print("fetch with error")
    }
    
    
    func fetchSecond() {
        interactor?.getSecond()?
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    print("Finished")
                }
            }, receiveValue: { [weak self] response in
                self?.view?.displaySecondList(response.list)
                CacheManager.shared.saveListToCache(products: response.list, key: CacheManager.secondListKey)
            })
            .store(in: &cancellables)
    }
    
    func fetchThird() {
        interactor?.getThird()?
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    print("Finished")
                }
            }, receiveValue: { [weak self] response in
                self?.view?.displayThirdList(response.list)
                CacheManager.shared.saveListToCache(products: response.list, key: CacheManager.thirdListKey)
            })
            .store(in: &cancellables)
    }
    
    
    
}

extension DiscoverPresenter: DiscoverInteractorOutput {
    func didFetchFirstList(_ products: [DiscoverListResponse]) {
        view?.displayFirstList(products)
    }
    
    func didFetchSecondList(_ products: [DiscoverListResponse]) {
        view?.displaySecondList(products)
    }
    
    func didFetchThirdList(_ products: [DiscoverListResponse]) {
        view?.displayThirdList(products)
    }
    
    
}
