//
//  FlowChartsUITests.swift
//  FlowChartsUITests
//
//  Created by Alexandr Kozlov on 11/06/16.
//  Copyright © 2016 Brown Coats. All rights reserved.
//

import XCTest

class FlowChartsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
//        let app = XCUIApplication()
//        let scrollViewsQuery = app.scrollViews
//        let element = scrollViewsQuery.children(matching: .other).element.children(matching: .other).element(boundBy: 3)
//        let coordinate = element.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.1))
//        coordinate.tap()
//        
//        let ex = expectation(description: "test")
//        waitForExpectations(timeout: 10.0) { (errir) in
//            
//        }
        
//        let app = XCUIApplication()
//        
//        let scrollViewsQuery = app.scrollViews
//        scrollViewsQuery.children(matching: .other).element.children(matching: .other).element(boundBy: 3).tap()
//        scrollViewsQuery.children(matching: .button).element.tap()
//        let element = app.collectionViews.children(matching: .cell).element(boundBy: 4).children(matching: .other).element
//        element.tap()
        
        // assert symbol is visible
        // assert popover dismissed
        
        
    }
    
}
