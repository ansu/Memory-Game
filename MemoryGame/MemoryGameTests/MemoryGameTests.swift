//
//  MemoryGameTests.swift
//  MemoryGameTests
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import XCTest
@testable import MemoryGame

extension XCTestCase {
    
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")
        
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
}

class MemoryGameTests: XCTestCase {
    
    var network:Network?
    var api:API?
    var viewModel:GameViewModelling?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
         network = MockNetworkProvider()
         api = API(network: network!)
         viewModel = GameViewModelling(api: api!)
        
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCardsCount() {
       
        viewModel!.getImages()
        let count = viewModel!.cards.count
        XCTAssertTrue(count == 2, "Success")
        
    }
    
    func testCardsIsShown(){
        viewModel!.getImages()
        let cards = viewModel!.cards
        for i in 0...cards.count-1 {
            let shown = cards[i].shown
            XCTAssertTrue(shown , "Success")
        }
    }
    func testLoadingFlag(){
        viewModel!.getImages()
        let loading = viewModel!.isLoading.value
        XCTAssertTrue(loading == false, "Success")
        
    }
    
    func testTimerFlag(){
        viewModel!.getImages()
        let waitTime = Double(AppConstants.cardsDisplayTime) ?? 0.0
        wait(for: waitTime)
        let elapsedTimeValue = viewModel!.elapsedTime.value
        let assertValue = String(format: "TIMER: --- %@", AppConstants.cardsDisplayTime)
        XCTAssertTrue(elapsedTimeValue == assertValue, "Success")
    
    }
    
    func testCardsIsHidden(){
        viewModel!.getImages()
        let waitTime = Double(AppConstants.cardsDisplayTime) ?? 0.0
        wait(for: waitTime)
        let cards = viewModel!.cards
        for i in 0...cards.count-1 {
            let shown = cards[i].shown
            XCTAssertFalse(shown , "Success")
        }
    }
    
    
    
    
    
}
