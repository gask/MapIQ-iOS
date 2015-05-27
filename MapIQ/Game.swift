//
//  Game.swift
//  MapIQ
//
//  Created by Francisco F Neto on 27/04/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import Foundation
import UIKit

class Game : UIViewController, UIGestureRecognizerDelegate {
    
    var mapWidth = Double(320)
    var mapHeight = Double(320)
    var mapName = ""
    
    var animationGoing = false
    
    @IBOutlet var placeName: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var hintBtn: UIButton!
    
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
        hintBtn.hidden = true
        
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
                self.timeOver1.removeFromSuperview()
            } else {
                self.timeImage.addSubview(self.timeOver1)
            }
            
            if self.timeOver2.isDescendantOfView(self.timeImage) {
                self.timeOver2.removeFromSuperview()
            } else {
                self.timeImage.addSubview(self.timeOver2)
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
        
        hintdiameter = 100.0/320.0*self.mapWidth/Double(hintTimes)
        
        //decideMapSize(screenSize)
        
        rightPoint = getPixelPoint(rightCoordinate)
        rightFlag.frame = CGRect(x: rightPoint.x-20, y: rightPoint.y-40, width: 40, height: 40)
        let hintPoint = hintCoordinate != nil ? getPixelPoint(hintCoordinate) : CGPoint(x: 0.0, y: 0.0)
        hintCircle.frame = hintCoordinate != nil ? CGRect(x: hintPoint.x-CGFloat(hintdiameter/2), y: hintPoint.y-CGFloat(hintdiameter/2), width: CGFloat(hintdiameter), height: CGFloat(hintdiameter)) : CGRectZero
        
        self.hintMovingCircle.frame = hintCircle.frame
        self.hintMovingCircle.layer.removeAllAnimations()
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .Repeat | .Autoreverse , animations: { () -> Void in
            var newFrame = self.hintMovingCircle.frame
            newFrame.size.width = 1.0
            newFrame.size.height = 1.0
            newFrame.origin.x = CGFloat(hintPoint.x-1/2)
            newFrame.origin.y = CGFloat(hintPoint.y-1/2)
            self.hintMovingCircle.frame = newFrame
            }, completion: nil)
        
        if myCoordinate != nil {
            myPoint = getPixelPoint(myCoordinate)
            myFlag.frame = CGRect(x: myPoint.x-20, y: myPoint.y-40, width: 40, height: 40)
            
            distanceCircle.removeFromSuperview()
            distanceCircleRight.removeFromSuperview()
            distanceCircleLeft.removeFromSuperview()
            
            
            createOrChangeDistanceCircles(false)
        }
        
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        let screenSize = CGRect(x: UIScreen.mainScreen().bounds.origin.y, y: UIScreen.mainScreen().bounds.origin.x, width: UIScreen.mainScreen().bounds.size.height, height: UIScreen.mainScreen().bounds.size.width)
        
        decideMapSize(screenSize)
    }
    
    func decideMapSize(screenSize: (CGRect)) {
        if mapName == "world" {
            mapWidth = Double(screenSize.width)
            mapHeight = Double(screenSize.width)
            
            //println("screensize: \(screenSize)")
            if screenSize.width < screenSize.height {
                self.map.frame = CGRect(x: Double(screenSize.width)/2-self.mapWidth/2, y: Double(screenSize.height)/2-self.mapHeight/2, width: Double(screenSize.width), height: Double(screenSize.width))
            }
            else {
                self.map.frame = CGRect(x: 0, y: Double(screenSize.height)/2-Double(screenSize.width)/2, width: Double(screenSize.width), height: Double(screenSize.width))
                
            }
        } else {
            mapWidth = screenSize.width < screenSize.height ? Double(screenSize.width) : Double(screenSize.height)
            mapHeight = screenSize.width < screenSize.height ? Double(screenSize.width) : Double(screenSize.height)
            
            //println("screensize: \(screenSize)")
            self.map.frame = CGRect(x: Double(screenSize.width)/2-self.mapWidth/2, y: Double(screenSize.height)/2-self.mapHeight/2, width: self.mapWidth, height: self.mapHeight)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let screenSize = UIScreen.mainScreen().bounds
        
        rightPoint = getPixelPoint(rightCoordinate)
        
        decideMapSize(screenSize)
        
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
                                self.hintBtn.hidden = false
                                self.countdownImg.removeFromSuperview()
                                self.countdownFlashOne.removeFromSuperview()
                                self.countdownFlashTwo.removeFromSuperview()
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
    
    func getCoordinate(pixelPoint: CGPoint) -> CGPoint {
        
        var mapMultiplier = CGFloat(1.0)
        var xBorder = CGFloat(0.0)
        var yBorder = CGFloat(0.0)
        var mapW = mapWidth
        var mapH = mapHeight
        
        if mapName == "france" {
            mapMultiplier = CGFloat(2600.0/mapWidth)
            xBorder = 33050.9
            yBorder = 22685.7
            mapW = 68096.0
            mapH = 68096.0
        } else if mapName == "uk" {
            mapMultiplier = CGFloat(3246.0/mapWidth)
            xBorder = 31612.4
            yBorder = 19933.4
            mapW = 68096.0
            mapH = 68096.0
        } else if mapName == "australia" {
            mapMultiplier = CGFloat(4014.0/mapWidth)
            xBorder = 27614.3
            yBorder = 17775.2
            mapW = 34038.0
            mapH = 34038.0
        } else if mapName == "china" {
            mapMultiplier = CGFloat(2975.0/mapWidth)
            xBorder = 11930.4
            yBorder = 5230.5
            mapW = 17024.0
            mapH = 17024.0
        } else if mapName == "brazil" {
            mapMultiplier = CGFloat(3898.0/mapWidth)
            xBorder = 9955.73
            yBorder = 16549.8
            mapW = 34038.0
            mapH = 34038.0
        } else if mapName == "usa" {
            mapMultiplier = CGFloat(2793.0/mapWidth)
            xBorder = 2602.31
            yBorder = 5103.87
            mapW = 17024.0
            mapH = 17024.0
        } else if mapName == "southafrica" {
            mapMultiplier = CGFloat(1803.0/mapWidth)
            xBorder = 18452.5
            yBorder = 18942.8
            mapW = 34038.0
            mapH = 34038.0
        }
        
        let adjustedPixelPoint = CGPoint(x: mapMultiplier*pixelPoint.x+xBorder, y: mapMultiplier*pixelPoint.y+yBorder)
        
        let pointLng = Double(adjustedPixelPoint.x) / (mapW/360.0) - 180.0
        
        let antiMercN = (2.0*M_PI)/mapW * (mapH/2.0 - Double(adjustedPixelPoint.y))
        let antiLatRad = 2*(atan(pow(M_E, antiMercN)) - M_PI/4)
        let pointLat = 180/M_PI * antiLatRad
        
        let latLon = CGPoint(x: pointLng, y: pointLat)
        
        return latLon
    }
    
    func getPixelPoint(coordinate: CGPoint, test:Bool=false) -> CGPoint {
        
        var mapMultiplier = CGFloat(1.0)
        var xBorder = CGFloat(0.0)
        var yBorder = CGFloat(0.0)
        var mapW = mapWidth
        var mapH = mapHeight
        
        if mapName == "france" {
            mapMultiplier = CGFloat(2600.0/mapWidth)
            xBorder = 33050.9
            yBorder = 22685.7
            mapW = 68096.0
            mapH = 68096.0
        } else if mapName == "uk" {
            mapMultiplier = CGFloat(3246.0/mapWidth)
            xBorder = 31612.4
            yBorder = 19933.4
            mapW = 68096.0
            mapH = 68096.0
        } else if mapName == "australia" {
            mapMultiplier = CGFloat(4014.0/mapWidth)
            xBorder = 27614.3
            yBorder = 17775.2
            mapW = 34038.0
            mapH = 34038.0
        } else if mapName == "china" {
            mapMultiplier = CGFloat(2975.0/mapWidth)
            xBorder = 11930.4
            yBorder = 5230.5
            mapW = 17024.0
            mapH = 17024.0
        } else if mapName == "brazil" {
            mapMultiplier = CGFloat(3898.0/mapWidth)
            xBorder = 9955.73
            yBorder = 16549.8
            mapW = 34038.0
            mapH = 34038.0
        } else if mapName == "usa" {
            mapMultiplier = CGFloat(2793.0/mapWidth)
            xBorder = 2602.31
            yBorder = 5103.87
            mapW = 17024.0
            mapH = 17024.0
        } else if mapName == "southafrica" {
            mapMultiplier = CGFloat(1803.0/mapWidth)
            xBorder = 18452.5
            yBorder = 18942.8
            mapW = 34038.0
            mapH = 34038.0
        }
        
        
        let x = (Double(coordinate.x) + 180.0) * (mapW/360.0)
        
        let latRad = Double(coordinate.y)*M_PI/180.0
        let mercN = log(tan((M_PI/4)+(latRad/2)))
        let y = (mapH/2)-(mapW*mercN/(2*M_PI))
        
        let pt = CGPoint(x: x, y: y)
        
        let adjustedPt = CGPoint(x: (pt.x-xBorder)/mapMultiplier, y: (pt.y-yBorder)/mapMultiplier)
        
        return test ? pt : adjustedPt
    }
    
    func tappedMap(sender: UITapGestureRecognizer) {
        //println("touched screen: \(sender)")
        
        if mapName == "teste" {
            //let mapMultiplier = CGFloat(2600.0/mapWidth);
            println(sender.locationInView(map))
            println("touch coord: \(getCoordinate(sender.locationInView(map)))")
            println("pixel back: \(getPixelPoint(getCoordinate(sender.locationInView(map))))")
            
            println("point west north \(mapName): \(getPixelPoint(CGPoint(x: 15.1611, y: -19.932), test: true))")
            //println("point east south \(mapName): \(getPixelPoint(CGPoint(x: 154.5018, y: -44.9648), test: true))")
            myPoint = sender.locationInView(map)
        } else {
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
                    
                    /*
                    for(int i = 0 ; i < Flow.Game.currentGame.myGuessList.Count ; i++)
                    {
                    int distanceComponent = (int) Math.Round(0.00008f*Math.Pow(Flow.Game.currentGame.myGuessList[i].distance/multiplier/constant,2)-1.1908f*Flow.Game.currentGame.myGuessList[i].distance/multiplier/constant+2400.6f,0);
                    if(distanceComponent < 0) distanceComponent = 0;
                    int timeComponent = (int) Math.Round((20*(maxTime-Flow.Game.currentGame.myGuessList[i].time)*timePoints),0);
                    
                    Flow.Game.currentGame.myGuessList[i].score = distanceComponent + timeComponent;
                    if(Flow.Game.currentGame.myGuessList[i].score < 0) Flow.Game.currentGame.myGuessList[i].score = 0;
                    
                    levelScore += Flow.Game.currentGame.myGuessList[i].score;
                    }
                    */
                    
                    
                    // z1 2128 - world
                    // z2 5256
                    // z3 8512
                    // z4 17024 - china, usa - 1/8
                    // z5 34038 - brazil, southafrica, australia - 1/16
                    // z6 68096 - france, uk - 1/32
                    
                    
                    var gi = GameEntry(distance: dist, coordinate: myCoordinate, score: getRoundScore(time: time, distance: dist), time: time, cityName: rightArray[roundCount].name)
                    coordinateArray.append(gi)
                    
                    self.nextBtn.hidden = false
                    self.hintBtn.hidden = true
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
        
    }
    
    var hintTimes = 0
    var hintCircle = UIImageView(image: UIImage(named:"orangeCircle"))
    var hintMovingCircle = UIImageView(image: UIImage(named:"orangeCircle"))
    var hintCoordinate : CGPoint!
    var hintdiameter = Double(0)
    
    @IBAction func getHint(sender: AnyObject) {
        hintTimes++
        hintdiameter = 100.0/320.0*self.mapWidth/Double(hintTimes)
        
        let randNumb = arc4random_uniform(UInt32(hintdiameter/2))
        let rndX = Double(randNumb)*2-hintdiameter/2
        let a = pow(hintdiameter/2,2)
        let b = pow(Double(rndX),2)
        let limY = sqrt(a - b)
        let randNumb2 = arc4random_uniform(UInt32(limY))
        let rndY = Double(randNumb2)*2-limY
        
        let hintX = rightPoint.x + CGFloat(rndX)
        let hintY = rightPoint.y + CGFloat(rndY)
        
        let hintFrame = CGRect(x: Double(hintX) - hintdiameter/2, y: Double(hintY) - hintdiameter/2, width:hintdiameter, height: hintdiameter)
        hintCoordinate = getCoordinate(CGPoint(x: hintX, y: hintY))
        println("hintCoord btn: \(hintCoordinate)")
        println("hintCircle btn: \(hintFrame)")
        
        hintCircle.frame = hintFrame
        hintMovingCircle.frame = hintFrame
        
        if !self.hintCircle.isDescendantOfView(map) {
            map.addSubview(hintCircle)
            map.addSubview(hintMovingCircle)
        }
        
        self.hintMovingCircle.layer.removeAllAnimations()
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .Repeat | .Autoreverse , animations: { () -> Void in
            var newFrame = self.hintMovingCircle.frame
            newFrame.size.width = 1.0
            newFrame.size.height = 1.0
            newFrame.origin.x = CGFloat(hintX-1/2)
            newFrame.origin.y = CGFloat(hintY-1/2)
            self.hintMovingCircle.frame = newFrame
        }, completion: nil)
        
        
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
            hintCircle.removeFromSuperview()
            hintMovingCircle.removeFromSuperview()
            hintTimes = 0
            
            rightCoordinate = rightArray[roundCount].coordinate
            rightPoint = getPixelPoint(rightCoordinate)
            placeName.text = rightArray[roundCount].name
            
            nextBtn.hidden = true
            hintBtn.hidden = false
            myCoordinate = nil
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
        var mapMult = Double(1.0)
        
        switch mapName {
        case "usa", "china":
            mapMult = Double(1/8)
        case "brazil", "southafrica", "australia":
            mapMult = Double(1/16)
        case "uk", "france":
            mapMult = Double(1/32)
        default:
            mapMult = Double(1)
        }
        
        let distcomp1 = Double(0.00008) * pow(dist/mapMult/5,2)
        let distcomp2 = Double(1.1908)*dist/mapMult/5 + Double(2400.6)
        
        var distanceComponent = Int(round(distcomp1 - distcomp2))
        if distanceComponent < 0 {
            distanceComponent = 0
        }
        var timeComponent = Int(round(Double(20)*(10.0-time)*Double(1.0)))
        let retVal = distanceComponent + timeComponent
        
        if retVal < 0 {
            return 0
        } else {
            return retVal
        }
        
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
                    }, completion: nil)
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
                    
                    }, completion: nil)
            }
            
        }
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
    
    
}