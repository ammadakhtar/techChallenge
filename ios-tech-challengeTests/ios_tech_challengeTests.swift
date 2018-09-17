//
//  ios_tech_challengeTests.swift
//  ios-tech-challengeTests
//
//  Created by Ammad Akhtar on 16/09/2018.
//  Copyright © 2018 Ammad Akhtar. All rights reserved.
//

import XCTest
@testable import ios_tech_challenge

class ios_tech_challengeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInit_DeliveryItemModel() {
        let testDelivery = DeliveryItem(id: 1, description: "Dummy description for testing", imageUrl: "https://www.dummyImageUrl.com", latitude: 22.27, longitude: 77.61, address: "Dummy Street Address")
        XCTAssertNotNil(testDelivery)
        XCTAssertEqual(testDelivery.id, 1)
        XCTAssertEqual(testDelivery.description, "Dummy description for testing")
        XCTAssertEqual(testDelivery.imageUrl, "https://www.dummyImageUrl.com")
        XCTAssertEqual(testDelivery.longitude, 77.61)
        XCTAssertEqual(testDelivery.latitude, 22.27)
        XCTAssertEqual(testDelivery.address, "Dummy Street Address")
    }
    
    // MARK: - Equatable Tests
    
    func testEquatable_ReturnsTrue() {
        let deliveryItem1 = DeliveryItem(id: 1, description: "Nice", imageUrl: "www.dummyImage.com", latitude: 22.71, longitude: 77.21, address: "Dummy address")
        let deliveryItem2 = DeliveryItem(id: 1, description: "Nice", imageUrl: "www.dummyImage.com", latitude: 22.71, longitude: 77.21, address: "Dummy address")
        XCTAssertEqual(deliveryItem1, deliveryItem2)
    }
}
