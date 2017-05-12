//
//  CardCellViewModel.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 12/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation



//class CardCellViewModel{
//   
//    private let card: Card1
//    private let imageCache: ImageCache
//    private var imageCacheCancellable: NetworkCancelable?
//    
//    
//    init(card: Card1, imageCache: ImageCache) {
//        self.card = card
//        self.imageCache = imageCache
//    }
//    deinit {
//        self.imageCacheCancellable?.cancel()
//    }
//    
//    //MARK: - Events
//    var didError: ((Error) -> Void)?
//    var didUpdate: (() -> Void)?
//   // var didSelectFriend: ((Friend) -> Void)?
//    
//    
//    private(set) var image: UIImage?
//    
//    func loadThumbnailImage() {
//        guard self.image == nil else { return } //ignore if we already have an image
//        guard self.imageCacheCancellable == nil else { return } //ignore if we are already fetching
//        
//        self.imageCacheCancellable = self.imageCache.image(
//            url: self.card.photoUrl!,
//            success: { [weak self] image in
//                guard let `self` = self else { return }
//                
//                self.image = image
//                self.didUpdate?()
//            },
//            failure: { [weak self] error in
//                self?.didError?(error)
//            }
//        )
//    }
//
//}


//extension CardCellViewModel: CellRepresentable {
//    static func registerCell(tableView: UITableView) {
//        tableView.registerNib(UINib(nibName: String(FriendCell), bundle: nil), forCellReuseIdentifier: String(FriendCell))
//    }
//    func dequeueCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(String(FriendCell), forIndexPath: indexPath) as! FriendCell
//        cell.uniqueId = indexPath
//        self.restrictedTo = indexPath
//        cell.setup(self)
//        return cell
//    }
//    func cellSelected() {
//        self.didSelectFriend?(self.friend)
//    }
//}
