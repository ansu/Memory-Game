//
//  Card.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//


import Foundation
import UIKit.UIImage



final class Card : CustomStringConvertible, Copying {
    
    // MARK: - Properties
    
    var id:NSUUID = NSUUID.init()
    var shown:Bool = true
    var photoUrl: URL?
    
    
    // MARK: - Lifecycle
    
    init(dictionary values: NSDictionary) {
        
        guard let media = values["media"] as? NSDictionary,
            let urlString = media["m"] as? String, let url = URL(string: urlString) else {
                fatalError("Photo item could not be created: " + values.description)
        }
        photoUrl = url
        
    }
    
    // MARK: - Methods
    
    required init(original: Card) {
        id = original.id
        shown = original.shown
        photoUrl = original.photoUrl
    }
    
    var description: String {
        return "\(id.uuidString)"
    }
    
    func equals(card: Card) -> Bool {
        return card.id.isEqual(id)
    }
}

