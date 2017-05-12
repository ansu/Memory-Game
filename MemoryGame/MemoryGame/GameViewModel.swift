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



protocol GameViewModel {
    func didSelectCard(cellIndex:Int)
    func getImages()
    var isLoading : Dynamic<Bool> { get }
    var cards:[Card] { get }
    var elapsedTime : Dynamic<String> { get }
   
    //MARK: - Events
    var didError: ((Error) -> Void)? { get set }
    var didUpdate: (() -> Void)? { get set }
    var showBottomCard:((Card) -> Void)? { get set }
    var showCard:((Int) -> Void)? {get set }
    var showToast:((String) -> Void)? {get set }
    var finishGame:((String) -> Void)? {get set }
    var startGame:(() ->Void)? { get set }

}


class GameViewModelling: NSObject, GameViewModel {
    
    private(set) var cards :[Card] = [Card]()
    private(set) var isLoading : Dynamic<Bool> = Dynamic(false)
    private(set) var elapsedTime : Dynamic<String> = Dynamic("")

    private var activeCard:Card?
    private var startTime:NSDate?
    private var timer:Timer?
    private var hiddenCards:[Card] = [Card]()
    private var  correctCardsCount = 0
    var didError: ((Error) -> Void)?
    var didUpdate: (() -> Void)?
    var showBottomCard:((Card) -> Void)?
    var showCard:((Int) -> Void)?
    var showToast:((String) -> Void)?
    var finishGame:((String) -> Void)?
    var startGame:(() ->Void)?

 
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
            self?.timer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(GameViewModelling.mySelector), userInfo: nil, repeats: true)
            
            }
     
        }
    
    func mySelector(){
        let time = String(format:"%.0f",NSDate().timeIntervalSince(startTime! as Date))
        elapsedTime.value = String(format:"TIMER: --- %@",time)
        
        if time == AppConstants.cardsDisplayTime {
            if timer?.isValid == true {
                timer?.invalidate()
                timer = nil
            }
            self.hideAllCards()
            
            
        }
    }
    
    private func hideAllCards(){
        hiddenCards = cards.clone()
        cards = cards.map{ (card:Card) -> Card in
                 card.shown = false
                 return card
        }
        for i in 0...cards.count - 1{
            print(cards[i].id)
            print(hiddenCards[i].id)

        }
        self.didUpdate!()
        self.startGame!()
        self.showRandomCard()
        self.showBottomCard!(self.activeCard!)

    }

    func didSelectCard(cellIndex:Int) {
        
        if activeCard != nil && (activeCard?.equals(card: cards[cellIndex]))!{
            cards[cellIndex].shown = true
            correctCardsCount += 1
            self.showCard!(cellIndex)
            if correctCardsCount == cards.count {
                self.stopGame()
                self.finishGame!(DisplayStrings.MemoryGame.FINISHED)
                return
            }
            self.showRandomCard()
            self.showBottomCard!(self.activeCard!)

            
        }else{
            self.showToast!(DisplayStrings.MemoryGame.WRONGTAP)
        }
        
        
    }
    
    private func stopGame(){
        cards.removeAll()
        hiddenCards.removeAll()
        correctCardsCount = 0
    }
    private func showRandomCard() {
        print("hidden  count:\(hiddenCards.count)")
        if hiddenCards.count > 0 {
            let arrayKey = Int(arc4random_uniform(UInt32(hiddenCards.count)))
            print("array key:\(arrayKey)")
            self.activeCard = hiddenCards[arrayKey]
            hiddenCards.remove(at: arrayKey)
        }

    }

}

