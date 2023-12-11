//
//  Menu.swift
//  MapIQ
//
//  Created by Francisco F Neto on 25/05/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
class Menu : UIViewController {
    
    let underImage = UIImageView(image: UIImage(named: "underTitleMap"))
    let underImage2 = UIImageView(image: UIImage(named: "underTitleMap"))
    
    @IBOutlet var titleImage: UIImageView!
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        underImage.frame = CGRectZero
        underImage2.frame = CGRectZero
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        underImage.layer.removeAllAnimations()
        underImage2.layer.removeAllAnimations()
        
        underImage.frame = titleImage.frame
        underImage2.frame = CGRect(x: titleImage.frame.origin.x+titleImage.frame.size.width, y: titleImage.frame.origin.y, width: titleImage.frame.size.width, height: titleImage.frame.size.height)
        
        UIView.animate(withDuration: 15.0, delay: 0.0, options: .repeat) {
            var newFrame = self.titleImage.frame
            newFrame.origin.x = self.titleImage.frame.origin.x-self.titleImage.frame.size.width
            self.underImage.frame = newFrame
            
            let newFrame2 = self.titleImage.frame
            self.underImage2.frame = newFrame2
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let productIdentifiers = Set(["com.giovannibf.mapquiz.1000coinspack", "com.giovannibf.mapquiz.10000coinspack", "com.giovannibf.mapquiz.2500coinspack", "com.giovannibf.mapquiz.4000coinspack", "com.giovannibf.mapquiz.ingamehint"])
        underImage.frame = titleImage.frame
        underImage2.frame = CGRect(x: titleImage.frame.origin.x+titleImage.frame.size.width, y: titleImage.frame.origin.y, width: titleImage.frame.size.width, height: titleImage.frame.size.height)
        
        self.view.insertSubview(underImage, belowSubview: titleImage)
        self.view.insertSubview(underImage2, belowSubview: titleImage)
        
        UIView.animate(withDuration: 15.0, delay: 0.0, options: .repeat) {
            var newFrame = self.titleImage.frame
            newFrame.origin.x = self.titleImage.frame.origin.x-self.titleImage.frame.size.width
            self.underImage.frame = newFrame
            
            let newFrame2 = self.titleImage.frame
            self.underImage2.frame = newFrame2
        }
    }
}
