//
//  NetworkMonitor.swift
//  SwipeAssignment
//
//  Created by Hitesh Rupani on 02/02/25.
//

import Foundation
import Network

// MARK: - Internet Connection Monitor
class NetworkMonitor: ObservableObject {
    @Published private(set) var isConnected = false
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
