//
//  MemoryGame.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation

import Foundation
import UIKit.UIImage

// MARK: - MemoryGameDelegate

protocol MemoryGameDelegate {
    func memoryGameDidStart(game: MemoryGame)
    func memoryGame(game: MemoryGame, showCard cards: Card)
    func memoryGame(game: MemoryGame, showBottomCard cards: Card)
    func memoryGameDidEnd(game: MemoryGame, elapsedTime: NSTimeInterval)
}

// MARK: - MemoryGame

class MemoryGame {
    
    // MARK: - Properties
    
    static var defaultCardImages:[UIImage] = [
        UIImage(named: "brand1")!,
        UIImage(named: "brand2")!,
        UIImage(named: "brand3")!,
        UIImage(named: "brand4")!,
        UIImage(named: "brand5")!,
        UIImage(named: "brand6")!,
        UIImage(named: "brand6")!,
        UIImage(named: "brand6")!,
        UIImage(named: "brand6")!
    ];
    
    var nums = [0,1,2,3,4,5,6,7,8]
    
    var cards:[Card] = [Card]()
    var delegate: MemoryGameDelegate?
    var isPlaying: Bool = false
    
    private var cardsShown:[Card] = [Card]()
    private var startTime:NSDate?
    
    var numberOfCards: Int {
        get {
            return cards.count
        }
    }
    
    var elapsedTime : NSTimeInterval {
        get {
            guard startTime != nil else {
                return -1
            }
            return NSDate().timeIntervalSinceDate(startTime!)
        }
    }
    
    // MARK: - Methods
    
    func newGame(cardsData:[UIImage]) {
        cards = randomCards(cardsData)
        startTime = NSDate.init()
        isPlaying = true
        delegate?.memoryGameDidStart(self)
    }
    
    func stopGame() {
        //        isPlaying = false
        //        cards.removeAll()
        //        cardsShown.removeAll()
        startTime = nil
    }
    
    func didSelectCard(card: Card?, activeCard:Card) {
        guard let card = card else { return }
        
        
        if activeCard.equals(card){
            print("Done")
            cardsShown.append(card)
            delegate?.memoryGame(self, showCard: card)
            if cardsShown.count == cards.count {
                print("finished")
                finishGame()
            }else{
                print("calling")
                delegate?.memoryGame(self, showBottomCard: showRandomCard())
            }
        }else{
            // print("sorry")
        }
        
    }
    
    func cardAtIndex(index: Int) -> Card? {
        if cards.count > index {
            return cards[index]
        } else {
            return nil
        }
    }
    
    func indexForCard(card: Card) -> Int? {
        for index in 0...cards.count-1 {
            if card === cards[index] {
                return index
            }
        }
        return nil
    }
    
    private func finishGame() {
        isPlaying = false
        delegate?.memoryGameDidEnd(self, elapsedTime: elapsedTime)
    }
    
    
    private func randomCards(cardsData:[UIImage]) -> [Card] {
        var cards = [Card]()
        for i in 0...cardsData.count-1 {
            let card = Card.init(image: cardsData[i])
            cards.append(card)
        }
        cards.shuffle()
        return cards
    }
    
    func showRandomCard() -> Card{
        
        let arrayKey = Int(arc4random_uniform(UInt32(nums.count)))
        let randNum = nums[arrayKey]
        nums.removeAtIndex(arrayKey)
        print(randNum)
        return cards[randNum]
    }
    
}