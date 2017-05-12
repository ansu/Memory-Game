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



protocol GamePresenter {
    func startGame()
    func stopGame()
    func didSelectCard(cellIndex:Int)
    func getImages()
    var isLoading : Dynamic<Bool> { get }
    var cards:[Card] { get }
    
   
    //MARK: - Events
    var didError: ((Error) -> Void)? { get set }
    var didUpdate: (() -> Void)? { get set }
    var showBottomCard:((Card) -> Void)? { get set }
    var showCard:((Int) -> Void)? {get set }
    var showToast:((String) -> Void)? {get set }
    var finishGame:((String) -> Void)? {get set }
    

}


class GamePresenterImpl: NSObject, GamePresenter {
    
    private(set) var cards :[Card] = [Card]()
    private(set) var isLoading : Dynamic<Bool> = Dynamic(false)
   
    private var activeCard:Card?
    private var startTime:NSDate?
    private var timer:Timer?
    private var nums = [0,1,2,3,4,5,6,7,8]
    private var cardsShown:[Card] = [Card]()
    
    var didError: ((Error) -> Void)?
    var didUpdate: (() -> Void)?
    var showBottomCard:((Card) -> Void)?
    var showCard:((Int) -> Void)?
    var showToast:((String) -> Void)?
    var finishGame:((String) -> Void)?


    func startGame() {
        //print
        startTime = NSDate.init()
    }
    func stopGame() {
        
    }
    
    var elapsedTime : TimeInterval {
        get {
            guard startTime != nil else {
                return -1
            }
            return NSDate().timeIntervalSince(startTime! as Date)
        }
    }
    
    func getImages() {
        isLoading.value = true
        Card.getAllFeedPhotos { [weak self] (photos, error) in
            self?.isLoading.value = false
            guard error == nil else {
                self?.didError?(error!)
                return
            }
            self?.cards = photos!
            self?.didUpdate!()
            self?.startTime = NSDate.init()
            self?.timer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(GamePresenterImpl.mySelector), userInfo: nil, repeats: true)
            
            }
     
        }
    
    func mySelector(){
        let seconds = String(format:"%.0f",self.elapsedTime)
        if seconds == "5" {
            if timer?.isValid == true {
                timer?.invalidate()
                timer = nil
            }
            self.hideAllCards()
            
        }
    }
    
    private func hideAllCards(){
        cards = cards.map{ (card:Card) -> Card in
                 card.shown = false
                 return card
        }
        for i in 0...cards.count-1 {
            print(cards[i].shown)
        }
        self.didUpdate!()
        self.activeCard = self.showRandomCard()
        self.showBottomCard!(self.activeCard!)

    }

    func didSelectCard(cellIndex:Int) {
        
        
        if activeCard != nil && (activeCard?.equals(card: cards[cellIndex]))!{
            
            cards[cellIndex].shown = true
            cardsShown.append(cards[cellIndex])
            self.showCard!(cellIndex)
            if cardsShown.count == cards.count {
                self.finishGame!("Finished")
                return
            }
            self.activeCard = self.showRandomCard()
            self.showBottomCard!(self.activeCard!)

            
        }else{
            self.showToast!("Wrong Tap")
        }
        
        
    }
    
    private func showRandomCard() -> Card{
        let arrayKey = Int(arc4random_uniform(UInt32(nums.count)))
        let randNum = nums[arrayKey]
        nums.remove(at: arrayKey)
        print(randNum)
        return cards[randNum]
    }

}

