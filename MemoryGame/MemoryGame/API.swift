//
//  API.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 12/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation


enum APIError: Error, CustomStringConvertible {
    case InvalidResponse
    case NotFound
    case URLParsing
    var description: String {
        switch self {
        case .InvalidResponse: return "Received an invalid response"
        case .NotFound: return "Requested item was not found"
        case .URLParsing: return "Sorry, there was an error in url."
        }
    }
}

class API {
    //MARK: - Private
    private let network: Network
    
    //MARK: - Lifecycle
    init(network: Network) {
        self.network = network
    }
    
    //MARK: - Public
    func getAllFeedPhotos(completion:@escaping ([Card]?, Error?) -> Void) {
      
        guard let url = NSURL(string: APIUrls.getImages.returnURL()) else {
            completion(nil, APIError.URLParsing)
            return
        }
        self.network.makeRequest(request: url){ (result, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            if let dictionary = result as? NSDictionary, let items = dictionary["items"] as? [NSDictionary] {
                var photos = [Card]()
                var count = 0
                for item in items {
                    if (count == AppConstants.totalNumberOfCards){
                        break;
                    }
                    photos.append(Card(dictionary: item))
                    count += 1
                }
                completion(photos, nil)
            } else {
                completion(nil, APIError.InvalidResponse)
            }
        }
        

    }
}
    
