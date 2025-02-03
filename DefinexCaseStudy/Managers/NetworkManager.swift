//
//  NetworkManager.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 1.02.2025.
//

import Foundation
import Combine
import Network

class NetworkManager {
    static let shared = NetworkManager()
    private var monitor: NWPathMonitor
    private var isConnected: Bool = true
    private var connectivitySubject = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(connectivitySubject: PassthroughSubject<Bool, Never> = PassthroughSubject()) {
        self.monitor = NWPathMonitor()
        self.connectivitySubject = connectivitySubject
        let queue = DispatchQueue(label: "NetworkMonitorQueue")
        
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { [weak self] path in
            let isCurrentlyConnected = path.status == .satisfied
            if isCurrentlyConnected != self?.isConnected {
                self?.isConnected = isCurrentlyConnected
                self?.connectivitySubject.send(isCurrentlyConnected)
            }
        }
    }
    
    
    func checkInternetConnection() -> Bool {
        return isConnected
    }
    
    
    func observeNetworkConnection() -> AnyPublisher<Bool, Never> {
        return connectivitySubject.eraseToAnyPublisher()
    }
    
    
}
