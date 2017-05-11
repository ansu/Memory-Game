//
//  UIImage+Downloader.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//


import UIKit.UIImage

extension UIImage {
    static func downloadImage(url: NSURL, completion: ((UIImage?) -> Void)?) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            var image: UIImage? = nil
            
            defer {
                dispatch_async(dispatch_get_main_queue()) {
                    completion?(image)
                }
            }
            
            if let data = NSData(contentsOfURL: url) {
                image = UIImage(data: data)
            }
        }
    }
}