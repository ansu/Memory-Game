//
//  Navigation.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 12/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation
import UIKit

class Navigation {
    //MARK: - Private
    private let application: Application
    private let window: UIWindow
    //MARK: - Lifecycle
    init(window: UIWindow, application: Application) {
        self.application = application
        self.window = window
    }

    
    
//    //MARK: - Public
    func start() {
        let viewModel = GameViewModelling(api: self.application.api)
        let instance = UIStoryboard.mainStoryboard?.instantiateVC(GameVC.self)
        instance?.viewModel = viewModel
        self.window.rootViewController = instance
        self.window.makeKeyAndVisible()
      
    }
   
}
