//
//  Game.swift
//  MapIQ
//
//  Created by Francisco F Neto on 21/04/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import UIKit

class Game: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet var gameMap: GMSMapView!
    @IBOutlet var placeName: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var nextBtn: UIButton!

    var timer: NSTimer!
    var time = 10.0
    var rightCoordinate = CLLocationCoordinate2DMake(0.0, 0.0)
    var coordinateArray = [GameEntry]()
    var roundCount = 0
    var gameOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        gameMap.delegate = self
        
        rightCoordinate = CLLocationCoordinate2DMake(-23.5479106,-46.6360186)
        placeName.text = "São Paulo"
        
        let camera = GMSCameraPosition.cameraWithLatitude(rightCoordinate.latitude, longitude: rightCoordinate.longitude, zoom: kGMSMinZoomLevel)
        
        gameMap.animateToCameraPosition(camera)
        gameMap.settings.zoomGestures = false
        gameMap.settings.tiltGestures = false
        gameMap.settings.rotateGestures = false
        gameMap.settings.scrollGestures = false
        
        gameOn = true
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("changeCounter"), userInfo: nil, repeats: true)
    }

    func changeCounter() {
        time -= Double(0.1)
        let timeText = NSString(format: "%.1f",time)
        timeLabel.text = "\(timeText)s"
        
        if time <= 0 {
            timeLabel.text = "0.0s"
            timer.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        
        if gameOn {
            gameOn = false
            if roundCount < 5 {
                
                let distance = GMSGeometryDistance(rightCoordinate, coordinate)
                
                println("distance: \(distance)")
                
                var gi = GameEntry(distance: distance, point: coordinate, score: 0)
                coordinateArray.append(gi)
                
                timer.invalidate()
                
                nextBtn.hidden = false
                roundCount++
            }
            else {
                
                println("coord array: \(coordinateArray)")
            }
        }
    }
    
    @IBAction func nextRound(sender: UIButton) {
        //println("pele dourada")
        if roundCount < 5 {
            // rodada não terminou
            nextBtn.hidden = true
            gameOn = true
            time = 10
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("changeCounter"), userInfo: nil, repeats: true)
        }
        else {
            // jogo terminou
        }
        
    }

}

