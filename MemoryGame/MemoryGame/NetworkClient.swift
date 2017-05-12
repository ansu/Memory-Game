//
//  NetworkClient.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation
import UIKit



typealias NetworkResult = (AnyObject?, Error?) -> Void

class NetworkClient: NSObject {
    fileprivate var urlSession: Foundation.URLSession!
    private var backgroundSession: Foundation.URLSession!
    static let sharedInstance = NetworkClient()
    

    override init() {
        let configuration = URLSessionConfiguration.default
        urlSession = Foundation.URLSession(configuration: configuration)
        super.init()

    }
    
    
    // MARK: service methods
    
    func getData(url: NSURL, completion: @escaping NetworkResult) {
        let request = NSURLRequest(url: url as URL)
        let task = urlSession.dataTask(with: request as URLRequest) { [unowned self] (data, response, error) in
            guard let data = data else {
                OperationQueue.main.addOperation {
                    completion(nil, error)
                }
                return
            }
            self.parseJSON(data: data as NSData, completion: completion)
        }
        task.resume()
    }
    
        // MARK: helper methods
    
    private func parseJSON(data: NSData, completion: @escaping NetworkResult) {
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
    
    fileprivate func fixedJSONData(_ data: Data) -> Data {
        guard let jsonString = String(data: data, encoding: String.Encoding.utf8) else { return data }
        let fixedString = jsonString.replacingOccurrences(of: "\\'", with: "'")
        if let fixedData = fixedString.data(using: String.Encoding.utf8) {
            return fixedData
        } else {
            return data
        }
    }
    
}

