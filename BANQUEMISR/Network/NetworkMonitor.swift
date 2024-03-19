//
//  NetworkMonitor.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import Network
import Combine

class NetworkMonitor: ObservableObject {
	@Published var connectionState: ConnectionState = .offline
	static let shared = NetworkMonitor()
	
	private var monitor: NWPathMonitor?
	
	init() {
		monitor = NWPathMonitor()
		monitor?.pathUpdateHandler = { path in
			DispatchQueue.main.async {
				self.updateConnectionState(path)
			}
		}
		
		let queue = DispatchQueue(label: "NetworkMonitorQueue")
		monitor?.start(queue: queue)
	}
	private func updateConnectionState(_ path: NWPath) {
		if path.status == .satisfied {
			if path.usesInterfaceType(.wifi) {
				connectionState = .wifi
			} else if path.usesInterfaceType(.cellular) {
				connectionState = .cellular
			} else {
				connectionState = .online
			}
		} else {
			connectionState = .offline
		}
	}
	
	func isReachable() -> Bool {
		return connectionState != .offline
	}	
}
