//
//  GameEntry.swift
//  MapIQ
//
//  Created by Giovanni Barreira Ferraro on 4/23/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import Foundation

class GameEntry : NSObject {
    var distance: Double!
    var point: CLLocationCoordinate2D!
    var score: Int!
    
    init(distance dist: Double, point pt: CLLocationCoordinate2D, score scr: Int) {
        distance = dist
        point = pt
        score = scr
    }
    
    override var description : String {
        var desc = "GameEntry: {\r"
        desc += "distance: \(distance)\r"
        desc += "point: (\(point.latitude),\(point.longitude))\r"
        desc += "score: \(score)\r"
        desc += "}"
        
        return desc
    }
}