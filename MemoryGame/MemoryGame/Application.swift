//
//  Applications.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 12/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation
import UIKit

class Application {
    //MARK: - Dependencies
    private let window: UIWindow
    
    lazy var navigation: Navigation = Navigation(
        window: self.window,
        application: self
    )

    lazy var network = NetworkProvider(session: URLSession.shared)
    lazy var api: API = API(network:self.network )
    
//    //MARK: - Lifecycle
    init(window: UIWindow) {
        self.window = window
    }
}
