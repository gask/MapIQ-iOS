//
//  GameDeux.swift
//  MapIQ
//
//  Created by Francisco F Neto on 27/04/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import Foundation

class GameDeux : UIViewController {
    
    var mapWidth = Double(320)
    var mapHeight = Double(320)
    var mapName = "world"
    
    @IBOutlet var map: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let screenSize = UIScreen.mainScreen().bounds
        
        if mapName == "world" {
            println("oi")
            map.frame = CGRect(x: Double(screenSize.width)/2-mapWidth/2, y: Double(screenSize.height)/2-mapHeight/2, width: Double(screenSize.width), height: Double(screenSize.width))
            
        }
    }
    
    @IBAction func tappedMap(sender: UITapGestureRecognizer) {
        //println("touched screen: \(sender)")

        var point = sender.locationInView(map)
        println("pt: \(point)")
        
        
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
    
    func getPixelPoint(coordinate: CGPoint) -> CGPoint {
        
        let x = (Double(coordinate.x) + 180.0) * (mapWidth/360.0)
        
        let latRad = Double(coordinate.y)*M_PI/180.0
        let mercN = log(tan((M_PI/4)+(latRad/2)))
        let y = (mapHeight/2)-(mapWidth*mercN/(2*M_PI))
        
        let pt = CGPoint(x: x, y: y)
        
        return pt
    }
    
    func getCoordinate(pixelPoint: CGPoint) -> CGPoint {
        let pointLng = Double(pixelPoint.x) / (mapWidth/360.0) - 180.0
        
        let antiMercN = (2.0*M_PI)/mapWidth * (mapHeight/2.0 - Double(pixelPoint.y))
        let antiLatRad = 2*(atan(pow(M_E, antiMercN)) - M_PI/4)
        let pointLat = 180/M_PI * antiLatRad
        
        let latLon = CGPoint(x: pointLat, y: pointLng)
        
        return latLon
    }
}