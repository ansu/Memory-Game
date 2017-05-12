//
//  Network.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 12/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case Unknown
    case InvalidResponse
    
    var description: String {
        switch self {
        case .Unknown: return "An unknown error occurred"
        case .InvalidResponse: return "Received an invalid response"
        }
    }
}

protocol NetworkCancelable {
    func cancel()
}
extension URLSessionDataTask: NetworkCancelable { }

protocol Network {
     func makeRequest(request: NSURL, networkResult:@escaping (AnyObject?, Error?) -> Void)
}

