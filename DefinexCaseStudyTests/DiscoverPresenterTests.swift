//
//  DiscoverPresenterTests.swift
//  DefinexCaseStudyTests
//
//  Created by baran kutlu on 2.02.2025.
//

import XCTest
import Combine
@testable import DefinexCaseStudy

class DiscoverPresenterTests: XCTestCase {
    var presenter: DiscoverPresenter!
    var mockView: MockDiscoverView!
    var mockInteractor: MockDiscoverInteractor!
    var mockRouter: MockDiscoverRouter!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockView = MockDiscoverView()
        mockInteractor = MockDiscoverInteractor()
        mockRouter = MockDiscoverRouter()
        presenter = DiscoverPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testFetchFirst_Success() {
        let expectation = expectation(description: "fetchFirst should call displayFirstList")
        
        mockInteractor.mockResponse = DiscoverResponse(isSuccess: true, message: "test", statusCode: "test" ,list: [DiscoverListResponse(imageUrl: "test", description: "test", price: .init(value: 0.1, currency: "test"), oldPrice: .init(value: 0.1, currency: "test"), discount: "test", ratePercentage: 20)])
        
        presenter.fetchFirst()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockView.didCallDisplayFirstList)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
}


