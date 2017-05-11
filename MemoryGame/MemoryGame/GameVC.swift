//
//  GameVC.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//


import UIKit

class GameVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MemoryGameDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    var timerFlag:Bool = true
    var bottomImageView: UIImageView!
    
    let gameController = MemoryGame()
    var timer:NSTimer?
    
    var activeCard:Card?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        gameController.delegate = self
        setupNewGame()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if gameController.isPlaying {
            resetGame()
        }
    }
    
    // MARK: - Methods
    
    func resetGame() {
        gameController.stopGame()
        if timer?.valid == true {
            timer?.invalidate()
            timer = nil
        }
        collectionView.userInteractionEnabled = true
        collectionView.reloadData()
        timerLabel.text = String(format: "%@: ---", NSLocalizedString("TIME", comment: "time"))
        self.activeCard = gameController.showRandomCard()
        showItem()
        
    }
    
    
    
    func setupNewGame() {
        let cardsData:[UIImage] = MemoryGame.defaultCardImages
        gameController.newGame(cardsData)
    }
    
    func gameTimerAction() {
        
        let seconds = String(format:"%.0f",gameController.elapsedTime)
        let elapsedSeconds = String(format: "%@: %.0fs", NSLocalizedString("TIME", comment: "time"), gameController.elapsedTime)
        timerLabel.text = elapsedSeconds
        if seconds == "5" {
            timerFlag = false
            resetGame()
            
        }
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameController.numberOfCards > 0 ? gameController.numberOfCards : 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCell", forIndexPath: indexPath) as! CardCollectionViewCell
        cell.showCard(timerFlag, animted: false)
        
        guard let card = gameController.cardAtIndex(indexPath.item) else { return cell }
        cell.card = card
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CardCollectionViewCell
        
        if cell.shown { return }
        gameController.didSelectCard(cell.card, activeCard: activeCard!)
        collectionView.deselectItemAtIndexPath(indexPath, animated:true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //let numberOfColumns:Int = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        
        let itemWidth: CGFloat = CGRectGetWidth(collectionView.frame) / 3.0 - 15.0 //numberOfColumns as CGFloat - 10 //- (minimumInteritemSpacing * numberOfColumns))
        
        return CGSizeMake(itemWidth, itemWidth)
    }
    
    // MARK: - MemoryGameDelegate
    
    func memoryGameDidStart(game: MemoryGame) {
        collectionView.reloadData()
        collectionView.userInteractionEnabled = true
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "gameTimerAction", userInfo: nil, repeats: true)
        
    }
    
    func memoryGame(game: MemoryGame, showCard card: Card) {
        
        guard let index = gameController.indexForCard(card) else { return }
        let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection:0)) as! CardCollectionViewCell
        cell.showCard(true, animted: true)
    }
    
    func memoryGame(game: MemoryGame, hideCards cards: [Card]) {
        for card in cards {
            guard let index = gameController.indexForCard(card) else { continue }
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection:0)) as! CardCollectionViewCell
            cell.showCard(false, animted: true)
        }
    }
    
    func memoryGame(game: MemoryGame, showBottomCard card: Card){
        
        self.activeCard = card
        showItem()
    }
    
    
    func memoryGameDidEnd(game: MemoryGame, elapsedTime: NSTimeInterval) {
        timer?.invalidate()
        print("Final Done")
        bottomImageView.removeFromSuperview()
        //
        //        let elapsedTime = gameController.elapsedTime
        //
        //        let alertController = UIAlertController(
        //            title: NSLocalizedString("Hurrah!", comment: "title"),
        //            message: String(format: "%@ %.0f seconds", NSLocalizedString("You finished the game in", comment: "message"), elapsedTime),
        //            preferredStyle: .Alert)
        //
        //        let saveScoreAction = UIAlertAction(title: NSLocalizedString("Save Score", comment: "save score"), style: .Default) { [weak self] (_) in
        //            let nameTextField = alertController.textFields![0] as UITextField
        //            guard let name = nameTextField.text else { return }
        //            self?.savePlayerScore(name, score: elapsedTime)
        //            self?.resetGame()
        //        }
        //        saveScoreAction.enabled = false
        //        alertController.addAction(saveScoreAction)
        //
        //        alertController.addTextFieldWithConfigurationHandler { (textField) in
        //            textField.placeholder = NSLocalizedString("Your name", comment: "your name")
        //
        //            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification,
        //                object: textField,
        //                queue: NSOperationQueue.mainQueue()) { (notification) in
        //                saveScoreAction.enabled = textField.text != ""
        //            }
        //        }
        //
        //        let cancelAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "dismiss"), style: .Cancel) { [weak self] (action) in
        //            self?.resetGame()
        //        }
        //        alertController.addAction(cancelAction)
        //
        //        self.presentViewController(alertController, animated: true) { }
    }
    
    
    
    func showItem() {
        //show the selected image
        
        
        if let tag = bottomImageView?.tag where tag == 100 {
            bottomImageView.image = activeCard?.image
        }else{
            bottomImageView  = UIImageView(image:
                activeCard?.image)
            bottomImageView.backgroundColor = UIColor(red: 0.0, green: 0.0,
                                                      blue: 0.0, alpha: 0.5)
            bottomImageView.layer.cornerRadius = 5.0
            bottomImageView.layer.masksToBounds = true
            bottomImageView.translatesAutoresizingMaskIntoConstraints = false
            bottomImageView.tag = 100
            view.addSubview(bottomImageView)
            let conX = bottomImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
            let conBottom = bottomImageView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: bottomImageView.frame.height)
            let conWidth = bottomImageView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 0.33, constant: -50.0)
            let conHeight = bottomImageView.heightAnchor.constraintEqualToAnchor(bottomImageView.widthAnchor)
            
            NSLayoutConstraint.activateConstraints([conX, conBottom, conWidth, conHeight])
            view.layoutIfNeeded()
            
            conBottom.constant = -100
            conWidth.constant = 0.0
            
            UIView.animateWithDuration(0.33, delay: 0.0,
                                       usingSpringWithDamping: 0.6, initialSpringVelocity: 10.0,
                                       options: [.CurveEaseOut], animations: {
                                        self.view.layoutIfNeeded()
                }, completion: nil)
        }
        
        
        
        
        
    }
    
    
}

