//
//  APIUrls.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 12/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation

enum APIUrls: String {
    case getImages = "/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    private func baseURL() -> String {
        switch self {
        default:
            return "https://api.flickr.com/services/"
        }
    }
    
    func returnURL() -> String {
        return  self.baseURL() + self.rawValue
    }
    
}

