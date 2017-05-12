//
//  GameVC.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//


import UIKit
import Kingfisher
import Toast_Swift

class GameVC: UIViewController  {
    
    // MARK: Properties
    
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var presenter : GamePresenter!
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        presenter = GamePresenterImpl()
        setupBinding()
        presenter?.getImages()
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
        
        presenter?.showCard = { [weak self] cellIndex in
            let indexPath = NSIndexPath(row: cellIndex, section: 0)
            let cell = self?.collectionView.cellForItem(at: indexPath as IndexPath) as! CardCollectionViewCell
            cell.card = self?.presenter.cards[cellIndex]
        }
        
        presenter?.showToast = { [weak self] toastMsg in
            self?.view.makeToast(toastMsg, duration: 1, position: ToastPosition.bottom)

        }
        
        presenter?.finishGame = { [weak self] toastMsg in
            self?.view.makeToast(toastMsg, duration: 1, position: ToastPosition.bottom)
            
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
    
}

extension GameVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
}

extension GameVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectCard(cellIndex: indexPath.row)
   }

}




