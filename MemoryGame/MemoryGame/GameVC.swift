//
//  GameVC.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//


import UIKit
import Kingfisher

class GameVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
//    var timerFlag:Bool = true
//    var timer:Timer?
    
    var presenter : GamePresenter!
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        presenter = GamePresenterImpl()
        setupBinding()
        presenter?.getImages()
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = true

       // setupNewGame()

    }
    
    
    func setupBinding(){
       
        presenter?.isLoading.bindAndFire({
            if ($0){
                print("show loader")
            }else{
                print("hide loader")
            }
        })
      
        presenter?.didError  = { [weak self] error in
            self?.viewModelDidError(error: error)
        }

        presenter?.didUpdate = { _ in
            self.collectionView.reloadData()
        }
        
        presenter?.showBottomCard = { [weak self] card in
            self?.showItem(activeCard: card)
        }

        
    }
    
    private func viewModelDidError(error: Error) {
        UIAlertView(title: "Error", message: error.displayString(), delegate: nil, cancelButtonTitle: "OK").show()
    }
   
    func showItem(activeCard:Card) {
        //show the selected image
            let imageUrl = activeCard.photoUrl!
            self.bottomImageView.kf.setImage(with:imageUrl)
            UIView.animate(withDuration: 0.33, delay: 0.0,
                                       usingSpringWithDamping: 0.6, initialSpringVelocity: 10.0,
                                       options: [.curveEaseOut], animations: {
                                        self.bottomImageView.isHidden = false
                                        
                }, completion: nil)
        }
    
    


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.cards.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell1", for: indexPath) as! CardCollectionViewCell
        let card = presenter.cards[indexPath.row]
        cell.card = card

        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth: CGFloat = collectionView.frame.width / 3.0 - 15.0
        return CGSize(width: itemWidth, height: itemWidth)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CardCollectionViewCell
        
        //if cell.shown { return }
        presenter.didSelectCard(cellIndex: indexPath.row)
//        if let nationalPark = parksDataSource.parkForItemAtIndexPath(indexPath) {
//            performSegue(withIdentifier: "MasterToDetail", sender: nationalPark)
//        }
    }


//    

//
//    
//    
//    
//    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        
//        print("did select\(indexPath.row)")
////        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CardCollectionViewCell
////        
////        if cell.shown { return }
////        presenter.didSelectCard(cellIndex: indexPath.row)
////        //gameController.didSelectCard(cell.card, activeCard: activeCard!)
////        collectionView.deselectItem(at: indexPath as IndexPath, animated:true)
//    }
}

