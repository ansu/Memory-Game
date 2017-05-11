//
//  Card.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//


import Foundation
import UIKit.UIImage

class Card : CustomStringConvertible {
    
    // MARK: - Properties
    
    var id:NSUUID = NSUUID.init()
    var shown:Bool = false
    var image:UIImage
    
    // MARK: - Lifecycle
    
    init(image:UIImage) {
        self.image = image
    }
    
    init(card:Card) {
        self.id = card.id.copy() as! NSUUID
        self.shown = card.shown
        self.image = card.image.copy() as! UIImage
    }
    
    // MARK: - Methods
    
    var description: String {
        return "\(id.UUIDString)"
    }
    
    func equals(card: Card) -> Bool {
        return card.id.isEqual(id)
    }
}