//
//  NetworkClient.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation
import UIKit


enum NetworkClientError: Error {
    case ImageData
}

typealias NetworkResult = (AnyObject?, Error?) -> Void
typealias ImageResult = (UIImage?, Error?) -> Void
typealias ProgressBlock = (Float) -> Void

class NetworkClient: NSObject {
    fileprivate var urlSession: Foundation.URLSession!
    private var backgroundSession: Foundation.URLSession!
    private var completionHandlers = [URL: ImageResult]()
    static let sharedInstance = NetworkClient()
    

    override init() {
        let configuration = URLSessionConfiguration.default
        urlSession = Foundation.URLSession(configuration: configuration)
        super.init()
//        let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "com.ansu.memorygame")
//
//        backgroundSession = URLSession(configuration: backgroundConfiguration, delegate: self, delegateQueue: nil)
    }
    
    private var networkActivityCount: Int = 0 {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = (networkActivityCount > 0)
        }
    }
    
    // MARK: service methods
    
    func getURL(url: NSURL, completion: @escaping NetworkResult) {
        let request = NSURLRequest(url: url as URL)
        networkActivityCount += 1
        let task = urlSession.dataTask(with: request as URLRequest) { [unowned self] (data, response, error) in
            guard let data = data else {
                OperationQueue.main.addOperation {
                    self.networkActivityCount -= 1
                    completion(nil, error)
                }
                return
            }
            self.parseJSON(data: data as NSData, completion: completion)
        }
        task.resume()
    }
    
    func getImage(url: NSURL, completion: @escaping ImageResult) -> URLSessionDownloadTask {
        let request = NSURLRequest(url: url as URL)
        networkActivityCount += 1
        let task = urlSession.downloadTask(with: request as URLRequest) {
            (fileUrl, response, error) in
            guard let fileUrl = fileUrl else {
                OperationQueue.main.addOperation {
                    self.networkActivityCount -= 1
                    completion(nil, error)
                }
                return
            }
            // You must move the file or open it for reading before this closure returns or it will be deleted
            if let data = NSData(contentsOf: fileUrl), let image = UIImage(data: data as Data) {
                OperationQueue.main.addOperation {
                    self.networkActivityCount -= 1
                    completion(image, nil)
                }
            } else {
                OperationQueue.main.addOperation {
                    self.networkActivityCount -= 1
                    completion(nil, NetworkClientError.ImageData)
                }
            }
        }
        task.resume()
        return task
    }
    
    func getImageInBackground(url: NSURL, completion: ImageResult?) -> URLSessionDownloadTask {
        completionHandlers[url as URL] = completion
        let request = NSURLRequest(url: url as URL)
        networkActivityCount += 1
        let task = backgroundSession.downloadTask(with: request as URLRequest)
        task.resume()
        return task
    }
    
    // MARK: helper methods
    
    private func parseJSON(data: NSData, completion: @escaping NetworkResult) {
        do {
            let fixedData = fixedJSONData(data as Data)
            let parseResults = try JSONSerialization.jsonObject(with: fixedData, options: [])
            if let dictionary = parseResults as? NSDictionary {
                OperationQueue.main.addOperation {
                    self.networkActivityCount -= 1
                    completion(dictionary, nil)
                }
            } else if let array = parseResults as? [NSDictionary] {
                OperationQueue.main.addOperation {
                    self.networkActivityCount -= 1
                    completion(array as AnyObject?, nil)
                }
            }
        } catch let parseError {
            OperationQueue.main.addOperation {
                self.networkActivityCount -= 1
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

//extension NetworkClient: URLSessionDelegate, URLSessionDownloadDelegate {
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        if let error = error, let url = task.originalRequest?.url, let completion = completionHandlers[url] {
//            completionHandlers[url] = nil
//            OperationQueue.main.addOperation {
//                self.networkActivityCount -= 1
//                completion(nil, error)
//            }
//        }
//    }
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
////        if let url = downloadTask.originalRequest?.url, let progress = progressHandlers[url] {
////            let percentDone = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
////            OperationQueue.main.addOperation {
////                progress(percentDone)
////            }
////        }
//    }
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        // You must move the file or open it for reading before this closure returns or it will be deleted
//        if let data = try? Data(contentsOf: location), let image = UIImage(data: data), let request = downloadTask.originalRequest, let response = downloadTask.response {
//            let cachedResponse = CachedURLResponse(response: response, data: data)
//            self.urlSession.configuration.urlCache?.storeCachedResponse(cachedResponse, for: request)
//            if let url = downloadTask.originalRequest?.url, let completion = completionHandlers[url] {
//                completionHandlers[url] = nil
//                OperationQueue.main.addOperation {
//                    self.networkActivityCount -= 1
//                    completion(image, nil)
//                }
//            }
//        } else {
//            if let url = downloadTask.originalRequest?.url, let completion = completionHandlers[url] {
//                completionHandlers[url] = nil
//                OperationQueue.main.addOperation {
//                    self.networkActivityCount -= 1
//                    completion(nil, NetworkClientError.imageData)
//                }
//            }
//        }
//    }
//    
//    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let completionHandler = appDelegate.backgroundSessionCompletionHandler {
//            appDelegate.backgroundSessionCompletionHandler = nil
//            completionHandler()
//        }
//    }
//}

