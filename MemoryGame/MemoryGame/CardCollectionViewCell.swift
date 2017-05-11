//
//  CardCollectionViewCell.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation

import UIKit.UICollectionViewCell

class CardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card? {
        didSet {
            guard let card = card else { return }
            frontImageView.image = card.image
        }
    }
    
    private(set) var shown: Bool = false
    
    // MARK: - Methods
    
    func showCard(show: Bool, animted: Bool) {
        frontImageView.hidden = false
        backImageView.hidden = false
        shown = show
        
        if animted {
            if show {
                UIView.transitionFromView(backImageView,
                                          toView: frontImageView,
                                          duration: 0.5,
                                          options: [.TransitionFlipFromRight, .ShowHideTransitionViews],
                                          completion: { (finished: Bool) -> () in
                })
            } else {
                UIView.transitionFromView(frontImageView,
                                          toView: backImageView,
                                          duration: 0.5,
                                          options: [.TransitionFlipFromRight, .ShowHideTransitionViews],
                                          completion:  { (finished: Bool) -> () in
                })
            }
        } else {
            if show {
                bringSubviewToFront(frontImageView)
                backImageView.hidden = true
            } else {
                bringSubviewToFront(backImageView)
                frontImageView.hidden = true
            }
        }
    }
    
    
}