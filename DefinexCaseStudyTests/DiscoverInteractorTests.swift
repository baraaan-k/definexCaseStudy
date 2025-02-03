//
//  DiscoverInteractorTests.swift
//  DefinexCaseStudyTests
//
//  Created by baran kutlu on 2.02.2025.
//

import XCTest
import Combine
@testable import DefinexCaseStudy


class DiscoverInteractorTests: XCTestCase {
    var interactor: DiscoverInteractor!
    var mockOutput: MockDiscoverInteractorOutput!
    var mockAPIService: MockAPIService!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockOutput = MockDiscoverInteractorOutput()
        mockAPIService = MockAPIService()
        interactor = DiscoverInteractor()
        interactor.output = mockOutput
    }
    
    override func tearDown() {
        interactor = nil
        mockOutput = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testGetFirst_Success() {
        let expectation = expectation(description: "getFirst should return data")
        
        interactor.getFirst()?
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { response in
                XCTAssertEqual(response.list.count, 2)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2)
    }
}
