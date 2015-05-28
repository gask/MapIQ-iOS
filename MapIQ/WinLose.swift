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
    
    @IBOutlet var scoreLabel: UILabel!
    var gameVariables : [GameEntry] = []
    var nameLabels = [UILabel]()
    var distanceLabels = [UILabel]()
    var timeLabels = [UILabel]()
    var cityBarBackgrounds = [UIImageView]()
    var distanceBarBackgrounds = [UIImageView]()
    var timeBarBackgrounds = [UIImageView]()
    var accumulatedScore = 0
    
    override func viewDidLoad() {
        /*for view in self.view.subviews {
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
            println(gameVariables[i])
            nameLabels[i].text = gameVariables[i].city
            distanceLabels[i].text = String(format: "%.0f", gameVariables[i].distance)
            timeLabels[i].text = String(format: "%.1f", gameVariables[i].time)+"s"
        }*/
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // 180 70 70 = 320 (bloco)
        // 27 de altura
        let screenSize = UIScreen.mainScreen().bounds
        
        for i in 0...gameVariables.count { // includes the title label bar background
            let halfTotalSize = 27.0*6.0/2.0
            
            var cityBg = UIImageView(image: UIImage(named: "bar"))
            cityBg.frame = CGRect(x: -320.0, y: Double(screenSize.size.height)/2.0 - halfTotalSize + Double(i)*27.0, width: 180.0, height: 27.0)
            
            var cityLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 178.0, height: 25.0))
            cityLabel.center = cityBg.center
            cityLabel.text = i == 0 ? "City" : gameVariables[i-1].city
            cityLabel.textAlignment = .Center
            
            
            var distBg = UIImageView(image: UIImage(named: "bar"))
            distBg.frame = CGRect(x: -320.0+180.0, y: Double(screenSize.size.height)/2 - halfTotalSize + Double(i)*27.0, width: 70.0, height: 27.0)
            
            var distLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 68.0, height: 25.0))
            distLabel.center = distBg.center
            distLabel.text = i == 0 ? "Km" : String(format: "%.0f", gameVariables[i-1].distance)
            distLabel.textAlignment = .Center
            
            var timeBg = UIImageView(image: UIImage(named: "bar"))
            timeBg.frame = CGRect(x: -320.0+180.0+70.0, y: Double(screenSize.size.height)/2 - halfTotalSize + Double(i)*27.0, width: 70.0, height: 27.0)
            
            var timeLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 68.0, height: 25.0))
            timeLabel.center = timeBg.center
            timeLabel.text = i == 0 ? "Time" : String(format: "%.1f", gameVariables[i-1].time)+"s"
            timeLabel.textAlignment = .Center
            
            if i == 0 {
                cityLabel.font = UIFont.boldSystemFontOfSize(15.0)
                distLabel.font = UIFont.boldSystemFontOfSize(15.0)
                timeLabel.font = UIFont.boldSystemFontOfSize(15.0)
            }
            
            self.view.addSubview(cityBg)
            self.view.addSubview(distBg)
            self.view.addSubview(timeBg)
            
            self.view.addSubview(cityLabel)
            self.view.addSubview(distLabel)
            self.view.addSubview(timeLabel)
            
            cityBarBackgrounds.append(cityBg)
            distanceBarBackgrounds.append(distBg)
            timeBarBackgrounds.append(timeBg)
            nameLabels.append(cityLabel)
            distanceLabels.append(distLabel)
            timeLabels.append(timeLabel)
        }
        moveLabels(0)
        
        animateScore(0.5, targetScore: 4000, callback: Selector("uhu"))
    }
    
    func uhu() {
        println("maluco, executou isso aqui, sou o pelé")
    }
    
    func moveLabels(index:Int) {
        //println("index: \(index)")
        //println("view: \(self.nameLabels[index])")
        let screenSize = UIScreen.mainScreen().bounds
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseIn, animations: {
            var newFr1 = self.cityBarBackgrounds[index].frame
            var newFr2 = self.distanceBarBackgrounds[index].frame
            var newFr3 = self.timeBarBackgrounds[index].frame
            newFr1.origin.x = CGFloat(screenSize.size.width)/2.0 - 320.0/2.0
            newFr2.origin.x = CGFloat(screenSize.size.width)/2.0 - 320.0/2.0 + 180.0
            newFr3.origin.x = CGFloat(screenSize.size.width)/2.0 - 320.0/2.0 + 180.0 + 70.0
            
            var newFrLb1 = self.nameLabels[index].frame
            var newFrLb2 = self.distanceLabels[index].frame
            var newFrLb3 = self.timeLabels[index].frame
            newFrLb1.origin.x = CGFloat(screenSize.size.width)/2.0 - 320.0/2.0 + 1.0
            newFrLb2.origin.x = CGFloat(screenSize.size.width)/2.0 - 320.0/2.0 + 1.0 + 180.0 + 1.0
            newFrLb3.origin.x = CGFloat(screenSize.size.width)/2.0 - 320.0/2.0 + 1.0 + 180.0 + 70.0 + 1.0
            
            self.cityBarBackgrounds[index].frame = newFr1
            self.nameLabels[index].frame = newFrLb1
            self.distanceBarBackgrounds[index].frame = newFr2
            self.distanceLabels[index].frame = newFrLb2
            self.timeBarBackgrounds[index].frame = newFr3
            self.timeLabels[index].frame = newFrLb3
        }, completion: { finished -> Void in
            if index < self.cityBarBackgrounds.count-1 {
                if index != 0 {
                    self.accumulatedScore += self.gameVariables[index-1].score
                    //self.scoreLabel.text = "Score: \(self.accumulatedScore)"
                }
                self.moveLabels(index+1)
            }
        })
    }

    var timeElapsedScoreTimer = 0.0
    var accNumberScoreTimer = 0
    var callBackScoreTimer : Selector?
    func changeScoreLabel(timer: NSTimer) {
        println(accNumberScoreTimer)
        
        if let dict = timer.userInfo as? [String:AnyObject] {
            if let timeLimit = dict["time"] as? Double {
                if timeElapsedScoreTimer <= timeLimit {
                    if let targetScore = dict["target"] as? Int {
                        //println("adding \(Int(Double(targetScore)*0.01/timeLimit))")
                        //println("subtr \(targetScore - accNumberScoreTimer)")
                        if targetScore - accNumberScoreTimer <= Int(Double(targetScore)*0.01/timeLimit) {
                            accNumberScoreTimer = targetScore
                        } else {
                            accNumberScoreTimer += Int(Double(targetScore)*0.01/timeLimit)
                        }
                        
                        scoreLabel.text = "Score: \(accNumberScoreTimer)"
                    }
                } else {
                    
                    NSThread.detachNewThreadSelector(callBackScoreTimer!, toTarget:self, withObject: nil)
                    callBackScoreTimer = nil
                    timer.invalidate()
                    timeElapsedScoreTimer = 0.0
                    accNumberScoreTimer = 0
                }
            }
        }
        timeElapsedScoreTimer += 0.01
    }
    
    func animateScore(time: Double, targetScore: Int, callback: Selector = nil) {
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("changeScoreLabel:"), userInfo: ["time":time, "target":targetScore], repeats: true)
        callBackScoreTimer = callback
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
}