//
//  GameDeux.swift
//  MapIQ
//
//  Created by Francisco F Neto on 27/04/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import Foundation

class GameDeux : UIViewController, UIGestureRecognizerDelegate {
    
    var mapWidth = Double(320)
    var mapHeight = Double(320)
    var mapName = "world"
    
    var map: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = UIImageView(image: UIImage(named: mapName))
        map.userInteractionEnabled = true
        let tapRec = UITapGestureRecognizer(target: self, action: Selector("tappedMap:"))
        tapRec.delegate = self
        map.addGestureRecognizer(tapRec)
        self.view.addSubview(map)
        
        rightCoordinate = CGPoint(x: -46.6360186,y: -23.5479106)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        let screenSize = UIScreen.mainScreen().bounds
        
        if mapName == "world" {
            mapWidth = Double(screenSize.width)
            mapHeight = Double(screenSize.width)
            //println("screensize: \(screenSize)")
            if screenSize.width < screenSize.height {
                map.frame = CGRect(x: Double(screenSize.width)/2-mapWidth/2, y: Double(screenSize.height)/2-mapHeight/2, width: Double(screenSize.width), height: Double(screenSize.width))
            }
            else {
                map.frame = CGRect(x: 0, y: Double(screenSize.height)/2-Double(screenSize.width)/2, width: Double(screenSize.width), height: Double(screenSize.width))
            }
            

        }
        
        rightPoint = getPixelPoint(rightCoordinate)
        myPoint = getPixelPoint(myCoordinate)
        rightFlag.frame = CGRect(x: rightPoint.x-20, y: rightPoint.y-40, width: 40, height: 40)
        myFlag.frame = CGRect(x: myPoint.x-20, y: myPoint.y-40, width: 40, height: 40)
    }
    
    override func viewDidAppear(animated: Bool) {
        let screenSize = UIScreen.mainScreen().bounds
        map.frame = CGRect(x: Double(screenSize.width)/2-mapWidth/2, y: Double(screenSize.height)/2-mapHeight/2, width: Double(screenSize.width), height: Double(screenSize.width))
        
        
    }
    
    var rightFlag = UIImageView(image: UIImage(named:"blueFlag"))
    var myFlag = UIImageView(image: UIImage(named:"pinkFlag"))
    var rightPoint : CGPoint!
    var myPoint : CGPoint!
    var rightCoordinate : CGPoint!
    var myCoordinate : CGPoint!
    
    func tappedMap(sender: UITapGestureRecognizer) {
        //println("touched screen: \(sender)")
        rightFlag.removeFromSuperview()
        myFlag.removeFromSuperview()
        if distanceCircle != nil {
            distanceCircle!.removeFromSuperview()
        }
        if distanceCircleRight != nil {
            distanceCircleRight!.removeFromSuperview()
        }
        if distanceCircleLeft != nil {
            distanceCircleLeft!.removeFromSuperview()
        }
        
        
        myPoint = sender.locationInView(map)
        println("myPoint at click: \(myPoint)")
        
        rightPoint = getPixelPoint(rightCoordinate)
        
        rightFlag.frame = CGRect(x: rightPoint.x-20, y: rightPoint.y-40, width: 40, height: 40)
        map.addSubview(rightFlag)
        
        myFlag.frame = CGRect(x: myPoint.x-20, y: myPoint.y-40, width: 40, height: 40)
        map.addSubview(myFlag)
        
        myCoordinate = getCoordinate(myPoint)
        
        var horizontalCathetus : CGFloat
        let leftEdgePoint = getPixelPoint(CGPoint(x:-180,y:0))
        let rightEdgePoint = getPixelPoint(CGPoint(x:179.99,y:0))
        var diameter : CGFloat
        
        if myPoint.x > rightPoint.x {
            horizontalCathetus = rightPoint.x - leftEdgePoint.x + rightEdgePoint.x - myPoint.x
        }
        else {
            horizontalCathetus = myPoint.x - leftEdgePoint.x + rightEdgePoint.x - rightPoint.x
        }
        let d1 = sqrt(pow((myPoint.y-rightPoint.y),2)+pow((myPoint.x-rightPoint.x),2))
        let d2 = sqrt(pow((myPoint.y-rightPoint.y),2)+pow((horizontalCathetus),2))
        
        if d1 < d2 {
            diameter = d1
            
            // apenas um circulo
            let xCenter = (myPoint.x + rightPoint.x)/2
            let yCenter = (myPoint.y + rightPoint.y)/2
            let xOrigin = xCenter-diameter/2
            let yOrigin = yCenter-diameter/2
            
            distanceCircle = createCircle(CGRect(x:xOrigin, y:yOrigin, width: diameter, height: diameter))
            
            map.addSubview(distanceCircle!)
            
        } else {
            diameter = d2
            //dois circulos
            
            let virtualRight : CGPoint
            let virtualLeft : CGPoint
            let centerRight : CGPoint
            let centerLeft : CGPoint
            
            if myPoint.x > rightPoint.x {
                virtualRight = CGPoint(x:myPoint.x+horizontalCathetus,y:rightPoint.y)
                virtualLeft = CGPoint(x:rightPoint.x-horizontalCathetus,y:myPoint.y)
                centerRight = CGPoint(x:(virtualRight.x+myPoint.x)/2, y:(virtualRight.y+myPoint.y)/2)
                centerLeft = CGPoint(x:(virtualLeft.x+rightPoint.x)/2, y:(virtualLeft.y+rightPoint.y)/2)
            } else {
                virtualRight = CGPoint(x:rightPoint.x+horizontalCathetus,y:myPoint.y)
                virtualLeft = CGPoint(x:myPoint.x-horizontalCathetus,y:rightPoint.y)
                centerRight = CGPoint(x:(virtualRight.x+rightPoint.x)/2, y:(virtualRight.y+rightPoint.y)/2)
                centerLeft = CGPoint(x:(virtualLeft.x+myPoint.x)/2, y:(virtualLeft.y+myPoint.y)/2)
            }
            
            distanceCircleRight = createCircle(CGRect(x:centerRight.x-diameter/2, y:centerRight.y-diameter/2, width: diameter, height: diameter))
            distanceCircleLeft = createCircle(CGRect(x:centerLeft.x-diameter/2, y:centerLeft.y-diameter/2, width: diameter, height: diameter))
            
            map.addSubview(distanceCircleRight!)
            map.addSubview(distanceCircleLeft!)
            //let xCenterOne =  ? (myPoi)
        }
        
    }
    
    var distanceCircleRight : UIView?
    var distanceCircleLeft : UIView?
    var distanceCircle : UIView?
    
    func getPixelPoint(coordinate: CGPoint) -> CGPoint {
        
        let x = (Double(coordinate.x) + 180.0) * (mapWidth/360.0)
        
        let latRad = Double(coordinate.y)*M_PI/180.0
        let mercN = log(tan((M_PI/4)+(latRad/2)))
        let y = (mapHeight/2)-(mapWidth*mercN/(2*M_PI))
        
        let pt = CGPoint(x: x, y: y)
        
        return pt
    }
    
    func calculateSecondCircle() {
        var horizontalCathetus = 0
        
    }
    
    func createCircle(frame: CGRect) -> UIView {
        var circleView = UIView(frame: frame)
        circleView.backgroundColor = UIColor.clearColor()
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: frame.size.width/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        var circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.redColor().CGColor
        circleLayer.lineWidth = 1.0;
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 1.0
        
        // Add the circleLayer to the view's layer's sublayers
        circleView.layer.addSublayer(circleLayer)
        
        return circleView
    }
    
    func getCoordinate(pixelPoint: CGPoint) -> CGPoint {
        let pointLng = Double(pixelPoint.x) / (mapWidth/360.0) - 180.0
        
        let antiMercN = (2.0*M_PI)/mapWidth * (mapHeight/2.0 - Double(pixelPoint.y))
        let antiLatRad = 2*(atan(pow(M_E, antiMercN)) - M_PI/4)
        let pointLat = 180/M_PI * antiLatRad
        
        let latLon = CGPoint(x: pointLng, y: pointLat)
        
        return latLon
    }
}