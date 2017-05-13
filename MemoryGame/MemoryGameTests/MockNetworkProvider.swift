//
//  MockNetworkProvider.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 13/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation
@testable import MemoryGame

//Mock API Provider
class MockNetworkProvider: Network {
    
    // MARK: service methods
    
    func makeRequest(request url: NSURL, networkResult:@escaping (AnyObject?, Error?) -> Void) {
        
        let tempDict:NSDictionary = ["m":"https://farm5.staticflickr.com/4178/33781741324_6e8b2bd164_m.jpg"]
        let tempArray = [ ["media":tempDict],["media":tempDict] ]
        let json :NSDictionary = ["items":tempArray]
        
        networkResult(json, nil)
    }
    
}
