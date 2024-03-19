//
//  ConnectionStateTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import XCTest

class ConnectionStateTests: XCTestCase {
	
	func testEnumCases() {
		XCTAssertEqual(ConnectionState.online, ConnectionState.online)
		XCTAssertEqual(ConnectionState.offline, ConnectionState.offline)
		XCTAssertEqual(ConnectionState.cellular, ConnectionState.cellular)
		XCTAssertEqual(ConnectionState.wifi, ConnectionState.wifi)
	}
}

