//
//  NetworkMonitorTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//
@testable import BANQUEMISR
import XCTest
import Network

class NetworkMonitorTests: XCTestCase {
	
	var networkMonitor: NetworkMonitor!
	
	override func setUp() {
		super.setUp()
		networkMonitor = NetworkMonitor.shared
	}
	
	override func tearDown() {
		networkMonitor = nil
		super.tearDown()
	}
	
	func testNetworkMonitor_ConnectionStateUpdate() {
		// Given
		let expectation = XCTestExpectation(description: "Connection state update")
		let expectedConnectionState: ConnectionState = .wifi
		
		// Create a mock NetworkPath object
		let mockPath = MockNetworkPath(isSatisfied: true, usesWiFi: true)
		
		DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
			// Simulate network connection update
			self.networkMonitor.updateConnectionState(mockPath)
			expectation.fulfill()
		}
		
		// Wait for the expectation to be fulfilled
		wait(for: [expectation], timeout: 3)
		
		// Then
		XCTAssertEqual(networkMonitor.connectionState, expectedConnectionState)
	}
	
	func testNetworkMonitor_IsReachable() {
		// Given
		let expectation = XCTestExpectation(description: "Check network reachability")
		
		DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
			let isReachable = self.networkMonitor.isReachable()
			
			// Then
			XCTAssertTrue(isReachable)
			expectation.fulfill()
		}
		
		// Wait for the expectation to be fulfilled
		wait(for: [expectation], timeout: 3)
	}	
}


// Protocol to represent network path
protocol NetworkPath {
		var status: NWPath.Status { get }
		func usesInterfaceType(_ interfaceType: NWInterface.InterfaceType) -> Bool
}

// Mock implementation of NetworkPath for testing
class MockNetworkPath: NetworkPath {
		private let isSatisfied: Bool
		private let usesWiFi: Bool
		
		init(isSatisfied: Bool, usesWiFi: Bool) {
				self.isSatisfied = isSatisfied
				self.usesWiFi = usesWiFi
		}
		
		var status: NWPath.Status {
				return isSatisfied ? .satisfied : .unsatisfied
		}
		
		func usesInterfaceType(_ interfaceType: NWInterface.InterfaceType) -> Bool {
				return usesWiFi && interfaceType == .wifi
		}
}

// NetworkMonitor class to be tested
class NetworkMonitor: ObservableObject {
		@Published var connectionState: ConnectionState = .offline
		static let shared = NetworkMonitor()
		
		private var monitor: NWPathMonitor?
		
		init() {
				monitor = NWPathMonitor()
				monitor?.pathUpdateHandler = { path in
						DispatchQueue.main.async {
							if let nPath = path as? NetworkPath{
								self.updateConnectionState(nPath)
							}
							
						}
				}
				
				let queue = DispatchQueue(label: "NetworkMonitorQueue")
				monitor?.start(queue: queue)
		}
		
		func updateConnectionState(_ path: NetworkPath) {
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

// ConnectionState enum
enum ConnectionState {
		case offline, wifi, cellular, online
}
