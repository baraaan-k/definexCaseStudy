//
//  NetworkManagerTests.swift
//  DefinexCaseStudyTests
//
//  Created by baran kutlu on 2.02.2025.
//


import XCTest
import Combine
@testable import DefinexCaseStudy


class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    var connectivitySubject: PassthroughSubject<Bool, Never>!
    
    override func setUp() {
        super.setUp()
        connectivitySubject = PassthroughSubject<Bool, Never>()
        networkManager = NetworkManager(connectivitySubject: connectivitySubject)
    }
    
    func testCheckInternetConnection() {
        let isConnected = networkManager.checkInternetConnection()
        XCTAssertNotNil(isConnected, "Internet connection status should not be nil")
    }
    
    func testObserveNetworkConnection() {
        let expectation = expectation(description: "Network status should be published")
        
        var receivedStatus: Bool?
        let cancellable = networkManager.observeNetworkConnection()
            .sink { status in
                receivedStatus = status
                expectation.fulfill()
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.connectivitySubject.send(true)
        }
        
        waitForExpectations(timeout: 2)
        XCTAssertNotNil(receivedStatus, "Should receive a network status update")
        cancellable.cancel()
    }
}
