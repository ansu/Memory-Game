//
//  AppDelegate.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var app: Application?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     BuddyBuildSDK.setup()
     
     
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.app = Application(window:window)
        self.window = window
        
        self.app?.navigation.start()
        Fabric.with([Crashlytics.self])

        return true
    }

   

}

