//
//  MusicVideoTests.swift
//  MusicVideoTests
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import XCTest
@testable import MusicVideo

class MusicVideoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: MusicVideo Tests
    // Test to confirm that the MusicVideo initializer returns when no data is provided
    func testMusicVideoInitialization() {
        let potentialItem = Videos(data: [:], quality: true)
        XCTAssertNotNil(potentialItem)
        
        let nameAsNumber = Videos(data: ["im":["name":8]], quality: true)
        XCTAssertNotNil(nameAsNumber)
    }
    
    func testApi() {
        let api = APIManager()
        api.loadData("", withHighQuality: true) { videos in
            XCTAssertNotNil(videos)
        }
        
        api.loadData("http://google.es", withHighQuality: true) { videos in
            XCTAssertNotNil(videos)
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
