//
//  NetworkClient.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation
import UIKit


class NetworkProvider: Network {
    
    let session: URLSession
    
    //MARK: - Lifecycle
    init(session: URLSession = URLSession.shared) {
        self.session = session
        
    }

    // MARK: service methods
    
    func makeRequest(request url: NSURL, networkResult:@escaping (AnyObject?, Error?) -> Void) {
        let request = NSURLRequest(url: url as URL)
        let task = self.session.dataTask(with: request as URLRequest) { [unowned self] (data, response, error) in
            guard let data = data else {
                OperationQueue.main.addOperation {
                    networkResult(nil, error)
                }
                return
            }
            self.parseJSON(data: data as NSData, completion: networkResult)
        }
        task.resume()
    }
    
    
    
    // MARK: helper methods
    
    private func parseJSON(data: NSData, completion: @escaping (AnyObject?, Error?) -> Void) {
        do {
            let fixedData = fixedJSONData(data as Data)
            let parseResults = try JSONSerialization.jsonObject(with: fixedData, options: [])
            if let dictionary = parseResults as? NSDictionary {
                OperationQueue.main.addOperation {
                    completion(dictionary, nil)
                }
            } else if let array = parseResults as? [NSDictionary] {
                OperationQueue.main.addOperation {
                    completion(array as AnyObject?, nil)
                }
            }
        } catch let parseError {
            OperationQueue.main.addOperation {
                completion(nil, parseError)
            }
        }
    }
    
    private func fixedJSONData(_ data: Data) -> Data {
        guard let jsonString = String(data: data, encoding: String.Encoding.utf8) else { return data }
        let fixedString = jsonString.replacingOccurrences(of: "\\'", with: "'")
        if let fixedData = fixedString.data(using: String.Encoding.utf8) {
            return fixedData
        } else {
            return data
        }
    }
    
}




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
