//
//  CardCollectionViewCell.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation
import Kingfisher


import UIKit.UICollectionViewCell

class CardCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!

    var card:Card? {
        didSet {
            guard let card = card else { return }
            if (card.shown) {
                frontImageView.kf.setImage(with: card.photoUrl)
                bringSubview(toFront: frontImageView)
                backImageView.isHidden = true
                frontImageView.isHidden = false
            } else {
                bringSubview(toFront: backImageView)
                frontImageView.isHidden = true
                backImageView.isHidden  = false
            }
            
        }
    }
    
}
