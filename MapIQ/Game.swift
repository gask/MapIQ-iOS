//
//  Game.swift
//  MapIQ
//
//  Created by Francisco F Neto on 27/04/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import Foundation

class Game : UIViewController, UIGestureRecognizerDelegate {
    
    var mapWidth = Double(320)
    var mapHeight = Double(320)
    var mapName = ""
    
    var animationGoing = false
    
    @IBOutlet var placeName: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var nextBtn: UIButton!
    
    @IBOutlet var countdownImg: UIImageView!
    @IBOutlet var countdownFlashOne: UIImageView!
    @IBOutlet var countdownFlashTwo: UIImageView!
    
    var timer: NSTimer!
    var time = 0.0
    var roundCount = 0
    var gameOn = false
    var coordinateArray = [GameEntry]()
    var rightArray : [Locale] = []
    
    var map: UIImageView!
    @IBOutlet var timeImage: UIImageView!
    let timeOver1 = UIImageView(image: UIImage(named: "timeOver1"))
    let timeOver2 = UIImageView(image: UIImage(named: "timeOver2"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightCoordinate = rightArray[roundCount].coordinate
        placeName.text = rightArray[roundCount].name
        
        map = UIImageView(image: UIImage(named: mapName))
        map.userInteractionEnabled = true
        let tapRec = UITapGestureRecognizer(target: self, action: Selector("tappedMap:"))
        tapRec.delegate = self
        map.addGestureRecognizer(tapRec)
        self.view.insertSubview(map, belowSubview: placeName)
        
        
    }
    
    func changeCounter() {
        time += Double(0.1)
        let timeText = NSString(format: "%.1f",time)
        timeLabel.text = "\(timeText)s"
        
        if time > 10 && !clockTicking {
            
            self.timeImage.addSubview(self.timeOver1)
            clockTicking = true
            
            startTimeAnimation()
        }
    }
    
    var clockTicking = false
    
    func startTimeAnimation() {
        if clockTicking {
            if self.timeOver1.isDescendantOfView(self.timeImage) {
                println("timeOver1 removed")
                self.timeOver1.removeFromSuperview()
            } else {
                self.timeImage.addSubview(self.timeOver1)
                println("timeOver1 added")
            }
            
            if self.timeOver2.isDescendantOfView(self.timeImage) {
                self.timeOver2.removeFromSuperview()
                println("timeOver2 removed")
            } else {
                self.timeImage.addSubview(self.timeOver2)
                println("timeOver2 added")
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.startTimeAnimation()
            })
        }
    }
    
    override func shouldAutorotate() -> Bool {
        if self.animationGoing {
            return false
        } else {
            return true
        }
        
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
        rightFlag.frame = CGRect(x: rightPoint.x-20, y: rightPoint.y-40, width: 40, height: 40)
        if myCoordinate != nil {
            myPoint = getPixelPoint(myCoordinate)
            myFlag.frame = CGRect(x: myPoint.x-20, y: myPoint.y-40, width: 40, height: 40)
            
            distanceCircle.removeFromSuperview()
            distanceCircleRight.removeFromSuperview()
            distanceCircleLeft.removeFromSuperview()
            
            createOrChangeDistanceCircles(false)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let screenSize = UIScreen.mainScreen().bounds
        
        mapWidth = Double(screenSize.width)
        mapHeight = Double(screenSize.width)
        if screenSize.width < screenSize.height {
            map.frame = CGRect(x: Double(screenSize.width)/2-mapWidth/2, y: Double(screenSize.height)/2-mapHeight/2, width: Double(screenSize.width), height: Double(screenSize.width))
        }
        else {
            map.frame = CGRect(x: 0, y: Double(screenSize.height)/2-Double(screenSize.width)/2, width: Double(screenSize.width), height: Double(screenSize.width))
        }
        
        self.animateCountdown(screenSize, times: 0)
        self.timeOver1.frame.size = self.timeImage.frame.size
        self.timeOver2.frame.size = self.timeImage.frame.size
    }
    
    func animateCountdown(screenSize:CGRect, times:Int) {
        
        self.countdownImg.image = UIImage(named: "countdown\(times+1)")
        self.countdownFlashOne.image = UIImage(named: "countdown\(times+1)-1")
        self.countdownFlashTwo.image = UIImage(named: "countdown\(times+1)-2")
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseIn, animations: {
            self.animationGoing = true
            var centerFrame = self.countdownImg.frame
            centerFrame.origin.x += screenSize.size.width/2+self.countdownImg.frame.size.width/2
            
            self.countdownImg.frame = centerFrame
            }, completion: { finished in
                
                self.countdownFlashOne.hidden = false
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    self.countdownFlashOne.hidden = true
                    self.countdownFlashTwo.hidden = false
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        self.countdownFlashTwo.hidden = true
                    });
                });
                
                UIView.animateWithDuration(0.5, delay: 0.5, options: .CurveEaseOut, animations: {
                    var endFrame = self.countdownImg.frame
                    endFrame.origin.x += screenSize.size.width/2+self.countdownImg.frame.size.width/2
                    
                    self.countdownImg.frame = endFrame
                    }, completion: { finishedTwo in
                        
                        if finishedTwo {
                            if times < 2 {
                                var originalFrame = self.countdownImg.frame
                                originalFrame.origin.x = -self.countdownImg.frame.size.width
                                self.countdownImg.frame = originalFrame
                                self.animateCountdown(screenSize, times: times+1)
                            } else {
                                self.animationGoing = false
                                self.gameOn = true
                                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("changeCounter"), userInfo: nil, repeats: true)
                            }
                        }
     
                })

        })
    }
    
    var rightFlag = UIImageView(image: UIImage(named:"blueFlag"))
    var myFlag = UIImageView(image: UIImage(named:"pinkFlag"))
    var rightPoint : CGPoint!
    var myPoint : CGPoint!
    var rightCoordinate : CGPoint!
    var myCoordinate : CGPoint!
    
    func tappedMap(sender: UITapGestureRecognizer) {
        //println("touched screen: \(sender)")
        
        if gameOn {
            
            gameOn = false
            if roundCount < 5 {
                
                myPoint = sender.locationInView(map)
                println("myPoint at click: \(myPoint)")
                rightPoint = getPixelPoint(rightCoordinate)
                myCoordinate = getCoordinate(myPoint)
                
                let dist = getDistanceBetweenCoordinates(rightCoordinate, coordTwo: myCoordinate)
                
                println("distance: \(dist)")
                
                timer.invalidate()
                
                var gi = GameEntry(distance: dist, coordinate: myCoordinate, score: getRoundScore(time: time, distance: dist), time: time, cityName: rightArray[roundCount].name)
                coordinateArray.append(gi)
                
                nextBtn.hidden = false
                clockTicking = false
                roundCount++
                
                rightFlag.frame = CGRect(x: rightPoint.x-20, y: rightPoint.y-40, width: 40, height: 40)
                map.addSubview(rightFlag)
                
                myFlag.frame = CGRect(x: myPoint.x-20, y: myPoint.y-40, width: 40, height: 40)
                map.addSubview(myFlag)
                
                createOrChangeDistanceCircles(true)
            }
        }
    }
    
    var hintTimes = 1
    
    @IBAction func getHint(sender: AnyObject) {
        let hintradius = Double(400/hintTimes)
        var rndX = arc4random_uniform(UInt32(hintradius))*UInt32(2)-UInt32(hintradius)
        var limY = sqrt(pow(hintradius,2)-pow(Double(rndX),2))
        var rndY = arc4random_uniform(UInt32(limY))*UInt32(2)-UInt32(limY)
    }
    
    @IBAction func nextRound(sender: UIButton) {
        //println("pele dourada")
        if roundCount < 5 {
            // rodada não terminou
            rightFlag.removeFromSuperview()
            myFlag.removeFromSuperview()
            distanceCircle.removeFromSuperview()
            distanceCircleRight.removeFromSuperview()
            distanceCircleLeft.removeFromSuperview()
            
            rightCoordinate = rightArray[roundCount].coordinate
            placeName.text = rightArray[roundCount].name
            
            nextBtn.hidden = true
            gameOn = true
            time = 0.0
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("changeCounter"), userInfo: nil, repeats: true)
        }
        else {
            // jogo terminou
            println("coord array: \(coordinateArray)")
            self.performSegueWithIdentifier("EndGame", sender: self)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EndGame" {
            var vc = segue.destinationViewController as! WinLose
            
            vc.gameVariables = coordinateArray
        }
    }
    
    func getRoundScore(time tim: Double, distance dist: Double) -> Int {
        
        return 0
    }
    
    let earthRadius = 6371.0
    
    func getDistanceBetweenCoordinates(coordOne: CGPoint, coordTwo: CGPoint) -> Double {
        
        let dLat =  (Double(coordOne.y) - Double(coordTwo.y)) / 180.0 * M_PI
        let dLon = (Double(coordOne.x) - Double(coordTwo.x)) / 180.0 * M_PI
        
        let lat1 = Double(coordTwo.y) / 180.0 * M_PI
        let lat2 = Double(coordOne.y) / 180.0 * M_PI
        
        let a = pow(sin(dLat/2),2) + pow(sin(dLon/2),2) * cos(lat1) * cos(lat2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        let d = earthRadius * c
        
        return d
    }
    
    var distanceCircleRight = UIImageView(image: UIImage(named: "redCircle"))
    var distanceCircleLeft = UIImageView(image: UIImage(named: "redCircle"))
    var distanceCircle = UIImageView(image: UIImage(named: "redCircle"))
    
    func createOrChangeDistanceCircles(animated:Bool) {
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
            var xOrigin = xCenter-diameter/2
            var yOrigin = yCenter-diameter/2
            distanceCircle.frame = CGRect(x:xOrigin, y:yOrigin, width: diameter, height: diameter)
            if animated {
                xOrigin = xCenter-1/2
                yOrigin = yCenter-1/2
                distanceCircle.frame = CGRect(x:xOrigin, y:yOrigin, width: 1, height: 1)
            }
            
            map.addSubview(distanceCircle)
            
            if animated {
                
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseIn , animations: {
                    var newFrame = self.distanceCircle.frame
                    newFrame.size.width = diameter
                    newFrame.size.height = diameter
                    newFrame.origin.x = xCenter-diameter/2
                    newFrame.origin.y = yCenter-diameter/2
                    
                    self.distanceCircle.frame = newFrame
                    }, completion: { finished in
                        
                })
            }
            
            
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
            
            distanceCircleRight.frame = CGRect(x:centerRight.x-diameter/2, y:centerRight.y-diameter/2, width: diameter, height: diameter)
            distanceCircleLeft.frame = CGRect(x:centerLeft.x-diameter/2, y:centerLeft.y-diameter/2, width: diameter, height: diameter)
            if animated {
                distanceCircleRight.frame = CGRect(x:centerRight.x-1/2, y:centerRight.y-1/2, width: 1, height: 1)
                distanceCircleLeft.frame = CGRect(x:centerLeft.x-1/2, y:centerLeft.y-1/2, width: 1, height: 1)
            }
            
            map.addSubview(distanceCircleRight)
            map.addSubview(distanceCircleLeft)
            if animated {
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseIn , animations: {
                    var newFrameLeft = self.distanceCircleLeft.frame
                    var newFrameRight = self.distanceCircleRight.frame
                    
                    newFrameLeft.size.width = diameter
                    newFrameLeft.size.height = diameter
                    newFrameLeft.origin.x = centerLeft.x-diameter/2
                    newFrameLeft.origin.y = centerLeft.y-diameter/2
                    newFrameRight.size.width = diameter
                    newFrameRight.size.height = diameter
                    newFrameRight.origin.x = centerRight.x-diameter/2
                    newFrameRight.origin.y = centerRight.y-diameter/2
                    
                    self.distanceCircleLeft.frame = newFrameLeft
                    self.distanceCircleRight.frame = newFrameRight
                    
                    }, completion: { finished in
                        
                })
            }
            
        }
    }
    
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