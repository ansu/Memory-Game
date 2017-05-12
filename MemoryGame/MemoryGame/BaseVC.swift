//
//  BaseVC.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 12/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    internal var activityIndicatorView : RUIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
    }
    
    fileprivate func initViewController() {
        activityIndicatorView = RUIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.center = self.view.center
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidesWhenStopped = true
    }
    
    
    
    func showActivityIndicator() {
          activityIndicatorView.startAnimating()
         self.view.bringSubview(toFront: activityIndicatorView)
    }
    
    
    
    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
    }
}

class RUIActivityIndicatorView: UIActivityIndicatorView {
    
    override init(activityIndicatorStyle style: UIActivityIndicatorViewStyle) {
        super.init(activityIndicatorStyle: style)
        _initRUIActivityIndicatorView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _initRUIActivityIndicatorView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _initRUIActivityIndicatorView()
    }
    
    fileprivate func _initRUIActivityIndicatorView() {
        self.hidesWhenStopped = true
        self.color = UIColor.gray
    }
}
