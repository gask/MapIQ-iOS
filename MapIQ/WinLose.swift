//
//  WinLose.swift
//  MapIQ
//
//  Created by Francisco F Neto on 11/05/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import Foundation
import UIKit

class WinLose : UIViewController {
    
    var gameVariables : [GameEntry] = []
    var nameLabels : [UILabel] = [UILabel](count: 5, repeatedValue: UILabel())
    var distanceLabels : [UILabel] = [UILabel](count: 5, repeatedValue: UILabel())
    var timeLabels : [UILabel] = [UILabel](count: 5, repeatedValue: UILabel())
    
    override func viewDidLoad() {
        for view in self.view.subviews {
            if let label = view as? UILabel {
                if label.tag > 0 && label.tag < 10 {
                    nameLabels[label.tag-1] = label
                } else if label.tag > 10 && label.tag < 20{
                    distanceLabels[label.tag-11] = label
                } else if label.tag > 20 {
                    timeLabels[label.tag-21] = label
                }
            }
        }
        
        for i in 0..<gameVariables.count {
            nameLabels[i].text = gameVariables[i].city
            distanceLabels[i].text = String(format: "%.0f", gameVariables[i].distance)
            timeLabels[i].text = String(format: "%.1f", gameVariables[i].time)+"s"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
}