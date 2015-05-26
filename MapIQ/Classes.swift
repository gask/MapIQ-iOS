//
//  Classes.swift
//  MapIQ
//
//  Created by Giovanni Barreira Ferraro on 4/23/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import Foundation

class GameEntry : NSObject {
    var distance: Double!
    var coordinate: CGPoint!
    var city : String
    var score: Int!
    var time: Double
    
    init(distance dist: Double, coordinate coord: CGPoint, score scr: Int, time tim: Double, cityName nm:String) {
        distance = dist
        coordinate = coord
        score = scr
        time = tim
        city = nm
    }
    
    override var description : String {
        var desc = "GameEntry: {\r"
        desc += "distance: \(distance)\r"
        desc += "coordinate: (\(coordinate.y),\(coordinate.x))\r"
        desc += "score: \(score)\r"
        desc += "time: \(time)\r"
        desc += "}"
        
        return desc
    }
}

class Theme: NSObject {
    var ID : Int
    var name : String
    var mapCode : String
    var parent : Int
    var locales : [Locale]
    var pointsToUnlock : Int
    var order : Int
    
    init(ID id:Int, name tName:String, mapCode mCode:String, parentTheme pTheme:Int, unlockPts: Int, tOrder: Int) {
        ID = id
        name = tName
        mapCode = mCode
        parent = pTheme
        locales = []
        pointsToUnlock = unlockPts
        order = tOrder
    }
    
    override var description : String {
        var desc = "Theme: {\r"
        desc += "ID: \(ID)\r"
        desc += "name: \(name)\r"
        desc += "mapCode: (\(mapCode)\r"
        desc += "parentTheme: (\(parent)\r"
        desc += "locales: (\(locales)\r"
        desc += "}"
        
        return desc
    }
}

class Locale : NSObject {
    
    var ID : Int
    //var latitude : Double
    //var longitude : Double
    var coordinate : CGPoint
    var name : String
    var date : NSDate?
    
    init(ID id: Int, latitude lat: Double, longitude lng: Double, name localeName: String) {
        ID = id
        //latitude = lat
        //longitude = lng
        coordinate = CGPoint(x: lng, y: lat)
        name = localeName
    }
    
    override var description : String {
        var desc = "Locale: {\r"
        desc += "ID: \(ID)\r"
        desc += "name: \(name)\r"
        desc += "coordinate: (\(coordinate.x),\(coordinate.y))\r"
        desc += "}"
        
        return desc
    }
}

class ThemeCell : UITableViewCell {
    
    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var maxLevel: UILabel!
    @IBOutlet var maxScore: UILabel!
    @IBOutlet var themeName: UILabel!
    @IBOutlet var themeImage: UIImageView!
    
}