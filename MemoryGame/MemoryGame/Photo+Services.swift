//
//  Photo+Services.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation

//enum APIServiceError: Error, CustomStringConvertible {
//    case NotImplemented
//    case URLParsing
//    case JSONStructure
//    
//    var description: String {
//        switch self {
//        case .NotImplemented: return "This feature has not been implemented yet"
//        case .URLParsing: return "Sorry, there was an error getting the photos"
//        case .JSONStructure: return "Sorry, the photo service returned something different than expected"
//        }
//    }
//
//}
//
//typealias PhotosResult = ([Card]?, Error?) -> Void
//
//extension Card {
//    class func getAllFeedPhotos(completion: @escaping PhotosResult) {
//        guard let url = NSURL(string: APIUrls.getImages.returnURL()) else {
//            completion(nil, APIServiceError.URLParsing)
//            return
//        }
//        NetworkClient.sharedInstance.getData(url: url) { (result, error) in
//            guard error == nil else {
//                completion(nil, error)
//                return
//            }
//            if let dictionary = result as? NSDictionary, let items = dictionary["items"] as? [NSDictionary] {
//                var photos = [Card]()
//                var count = 0
//                for item in items {
//                    if (count == AppConstants.totalNumberOfCards){
//                        break;
//                    }
//                    photos.append(Card(dictionary: item))
//                    count += 1
//                }
//                completion(photos, nil)
//            } else {
//                completion(nil, APIServiceError.JSONStructure)
//            }
//        }
//    }
//}
