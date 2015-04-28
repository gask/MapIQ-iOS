//
//  GameDeux.swift
//  MapIQ
//
//  Created by Francisco F Neto on 27/04/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import Foundation

class GameDeux : UIViewController {
    
    @IBOutlet var map: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tappedMap(sender: UITapGestureRecognizer) {
        //println("touched screen: \(sender)")

        var point = sender.locationInView(map)
        println("pt: \(point)")
        
        var mapWidth = Double(320)
        
        
        var lat = Double(-23.5479106)
        var lng = Double(-46.6360186)
        
        var x = (lng + 180.0) * (mapWidth/360.0)
        
        var latRad = lat*M_PI/180.0
        
        var mercN = log(tan((M_PI/4)+(latRad/2)))
        var y = (mapWidth/2)-(mapWidth*mercN/(2*M_PI))
        
        var pt = CGPoint(x: x, y: y)
        println("pxPnt: \(pt)")
        
        var tusca = UIView(frame:CGRect(x: x, y: y, width: 1, height: 1))
        tusca.backgroundColor = UIColor.redColor()
        map.addSubview(tusca)
        
        var pointLng = Double(point.x) / (mapWidth/360.0) - 180.0
        
        var antiMercN = (2.0*M_PI)/mapWidth * (mapWidth/2.0 - Double(point.y))
        //println("mercN = \(antiMercN)")
        var antiLatRad = 2*(atan(pow(M_E, antiMercN)) - M_PI/4)
        //println("latRad = \(antiLatRad)")
        var pointLat = 180/M_PI * antiLatRad
        //println("lat = \(pointLat)")
        

        
        var latLon = CGPoint(x: pointLat, y: pointLng)
        println("latLon: \(latLon)")
    }
}