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

class GameVC: BaseVC  {
    
    // MARK: Properties
    
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    fileprivate var viewModel : GameViewModel!
    
    // MARK: - Lifecycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        viewModel = GameViewModelling(api: appDelegate.api)
        setupBinding()
        viewModel?.getImages()
       // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
       
    }
    
    
    
     @IBAction func didPressPlayButton() {
        self.collectionView.isHidden = false
        self.playButton.isHidden = true
        self.timerLabel.isHidden = false
        viewModel?.getImages()
    }
    
    func setupBinding(){
       
        viewModel?.isLoading.bindAndFire({
            if ($0){
                self.showActivityIndicator()
            }else{
                self.hideActivityIndicator()
            }
        })
      
        viewModel?.didError  = { [weak self] error in
            self?.viewModelDidError(error: error)
        }

        viewModel?.didUpdate = { _ in
            self.collectionView.reloadData()
        }
        
        viewModel?.startGame = { [weak self] _ in
            self?.bottomImageView.isHidden = false
            self?.timerLabel.isHidden = true
            

        }
        viewModel?.showBottomCard = { [weak self] card in
            let imageUrl = card.photoUrl!
            self?.bottomImageView.kf.setImage(with:imageUrl)
            
        }
        
        viewModel?.showCard = { [weak self] cellIndex in
            let indexPath = NSIndexPath(row: cellIndex, section: 0)
            let cell = self?.collectionView.cellForItem(at: indexPath as IndexPath) as! CardCollectionViewCell
            cell.card = self?.viewModel.cards[cellIndex]
        }
        
        viewModel?.showToast = { [weak self] toastMsg in
            self?.view.makeToast(toastMsg, duration: 1, position: ToastPosition.bottom)

        }
        
        viewModel?.finishGame = { [weak self] toastMsg in
            self?.bottomImageView.isHidden = true
            self?.collectionView.isHidden = true
            self?.playButton.isHidden = false
            self?.view.makeToast(toastMsg, duration: 1, position: ToastPosition.bottom)
            
        }
        
        viewModel?.elapsedTime.bindAndFire({ elapsedTime in
            self.timerLabel.text = elapsedTime
        })
    }
    
    private func viewModelDidError(error: Error) {
        UIAlertView(title: "Error", message: error.displayString(), delegate: nil, cancelButtonTitle: "OK").show()
    }
   
    
    
}

extension GameVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell1", for: indexPath) as! CardCollectionViewCell
        let card = viewModel.cards[indexPath.row]
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
        viewModel.didSelectCard(cellIndex: indexPath.row)
   }

}




