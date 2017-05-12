//
//  NetworkRequest.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 12/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation

enum NetworkRequestError: Error, CustomStringConvertible {
    case InvalidURL(String)
        var description: String {
        switch self {
        case .InvalidURL(let url): return "The url '\(url)' was invalid"
        }
    }
}

struct NetworkRequest {
    //MARK: - HTTP Methods
    enum Method: String {
        case GET        = "GET"
        case PUT        = "PUT"
        case PATCH      = "PATCH"
        case POST       = "POST"
        case DELETE     = "DELETE"
    }
    
    //MARK: - Public Properties
    let method: NetworkRequest.Method
    let url: String
    
    //MARK: - Public Functions
    func buildURLRequest() throws -> NSURLRequest {
        guard let url = NSURL(string: self.url) else { throw NetworkRequestError.InvalidURL(self.url) }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = self.method.rawValue
        
        return request
    }
}
