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
    var lastLabelMoved = -1
    var labelMoving = -1
    let halfTotalSize = 27.0*6.0/2.0
    
    override func viewDidLoad() {
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 180 70 70 = 320 (bloco)
        // 27 de altura
        let screenSize = UIScreen.main.bounds
        
        for i in 0...gameVariables.count { // includes the title label bar background
            
            let cityBg = UIImageView(image: UIImage(named: "bar"))
            cityBg.frame = CGRect(x: -320.0, y: Double(screenSize.size.height)/2.0 - halfTotalSize + Double(i)*27.0, width: 180.0, height: 27.0)
            
            let cityLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 178.0, height: 25.0))
            cityLabel.center = cityBg.center
            cityLabel.text = i == 0 ? "City" : gameVariables[i-1].city
            cityLabel.textAlignment = .center
            
            
            let distBg = UIImageView(image: UIImage(named: "bar"))
            distBg.frame = CGRect(x: -320.0+180.0, y: Double(screenSize.size.height)/2 - halfTotalSize + Double(i)*27.0, width: 70.0, height: 27.0)
            
            let distLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 68.0, height: 25.0))
            distLabel.center = distBg.center
            distLabel.text = i == 0 ? "Km" : String(format: "%.0f", gameVariables[i-1].distance)
            distLabel.textAlignment = .center
            
            let timeBg = UIImageView(image: UIImage(named: "bar"))
            timeBg.frame = CGRect(x: -320.0+180.0+70.0, y: Double(screenSize.size.height)/2 - halfTotalSize + Double(i)*27.0, width: 70.0, height: 27.0)
            
            let timeLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 68.0, height: 25.0))
            timeLabel.center = timeBg.center
            timeLabel.text = i == 0 ? "Time" : String(format: "%.1f", gameVariables[i-1].time)+"s"
            timeLabel.textAlignment = .center
            
            if i == 0 {
                cityLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
                distLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
                timeLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
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
        moveLabels(index: 0)
        
        //animateScore(0.5, targetScore: 4000, callback: Selector("uhu"))
    }
    
    @objc func finishScoreAnimation(index: NSNumber) {
        print("maluco \(index.intValue) gmVar: \(self.gameVariables.count)")
        if index.intValue < self.gameVariables.count {
            print("maluco, executou isso aqui, sou o pelé \(index.intValue)")
            self.moveLabels(index: index.intValue+1)
        } else {
            print("maluco é o fim.")
        }
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        let screenSize = UIScreen.main.bounds
        
        if self.labelMoving != -1 {
            print("move a zica ae.")
            self.cityBarBackgrounds[self.labelMoving].layer.removeAllAnimations()
            self.nameLabels[self.labelMoving].layer.removeAllAnimations()
            self.distanceBarBackgrounds[self.labelMoving].layer.removeAllAnimations()
            self.distanceLabels[self.labelMoving].layer.removeAllAnimations()
            self.timeBarBackgrounds[self.labelMoving].layer.removeAllAnimations()
            self.timeLabels[self.labelMoving].layer.removeAllAnimations()
            
            self.cityBarBackgrounds[self.labelMoving].frame = CGRect(x: Double(screenSize.size.width)/2.0 - 320.0/2.0, y: Double(screenSize.size.height)/2.0 - halfTotalSize + Double(self.labelMoving)*27.0, width: 180.0, height: 27.0)
            self.nameLabels[self.labelMoving].frame = CGRect(x: 0.0, y: 0.0, width: 178.0, height: 25.0)
            self.nameLabels[self.labelMoving].center = self.cityBarBackgrounds[self.labelMoving].center
            self.distanceBarBackgrounds[self.labelMoving].frame = CGRect(x: Double(screenSize.size.width)/2.0 - 320.0/2.0 + 180.0, y: Double(screenSize.size.height)/2 - halfTotalSize + Double(self.labelMoving)*27.0, width: 70.0, height: 27.0)
            self.distanceLabels[self.labelMoving].frame = CGRect(x: 0.0, y: 0.0, width: 68.0, height: 25.0)
            self.distanceLabels[self.labelMoving].center = self.distanceBarBackgrounds[self.labelMoving].center
            self.timeBarBackgrounds[self.labelMoving].frame = CGRect(x: Double(self.distanceBarBackgrounds[self.labelMoving].frame.origin.x) + 70.0, y: Double(screenSize.size.height)/2 - halfTotalSize + Double(self.labelMoving)*27.0, width: 70.0, height: 27.0)
            self.timeLabels[self.labelMoving].frame = CGRect(x: 0.0, y: 0.0, width: 68.0, height: 25.0)
            self.timeLabels[self.labelMoving].center = self.timeBarBackgrounds[self.labelMoving].center
        }
        
        for k in 0...self.lastLabelMoved {
            self.cityBarBackgrounds[k].frame = CGRect(x: Double(screenSize.size.width)/2.0 - 320.0/2.0, y: Double(screenSize.size.height)/2.0 - halfTotalSize + Double(k)*27.0, width: 180.0, height: 27.0)
            self.nameLabels[k].frame = CGRect(x: 0.0, y: 0.0, width: 178.0, height: 25.0)
            self.nameLabels[k].center = self.cityBarBackgrounds[k].center
            self.distanceBarBackgrounds[k].frame = CGRect(x: Double(screenSize.size.width)/2.0 - 320.0/2.0 + 180.0, y: Double(screenSize.size.height)/2 - halfTotalSize + Double(k)*27.0, width: 70.0, height: 27.0)
            self.distanceLabels[k].frame = CGRect(x: 0.0, y: 0.0, width: 68.0, height: 25.0)
            self.distanceLabels[k].center = self.distanceBarBackgrounds[k].center
            self.timeBarBackgrounds[k].frame = CGRect(x: Double(self.distanceBarBackgrounds[k].frame.origin.x) + 70.0, y: Double(screenSize.size.height)/2 - halfTotalSize + Double(k)*27.0, width: 70.0, height: 27.0)
            self.timeLabels[k].frame = CGRect(x: 0.0, y: 0.0, width: 68.0, height: 25.0)
            self.timeLabels[k].center = self.timeBarBackgrounds[k].center
        }
    }
    
    func moveLabels(index:Int) {
        print("index: \(index)")
        print("view: \(self.nameLabels[index])")
        let screenSize = UIScreen.main.bounds
        
        let baseFrame = CGFloat(screenSize.size.width)/2.0 - 320.0/2.0
        let yDiscount = CGFloat(self.halfTotalSize) + CGFloat(index)*27.0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            print("animation \(index) started")
            
            self.labelMoving = index
            
            var newFr1 = self.cityBarBackgrounds[index].frame
            var newFr2 = self.distanceBarBackgrounds[index].frame
            var newFr3 = self.timeBarBackgrounds[index].frame
            newFr1.origin.x = baseFrame
            newFr2.origin.x = baseFrame + 180.0
            newFr3.origin.x = baseFrame + 180.0 + 70.0
            newFr1.origin.y = CGFloat(screenSize.size.height)/2.0 - yDiscount
            newFr2.origin.y = CGFloat(screenSize.size.height)/2.0 - yDiscount
            newFr3.origin.y = CGFloat(screenSize.size.height)/2.0 - yDiscount
            
            self.cityBarBackgrounds[index].frame = newFr1
            self.distanceBarBackgrounds[index].frame = newFr2
            self.timeBarBackgrounds[index].frame = newFr3
            
            var newFrLb1 = self.nameLabels[index].frame
            var newFrLb2 = self.distanceLabels[index].frame
            var newFrLb3 = self.timeLabels[index].frame
            
            newFrLb1.origin.x = baseFrame + 1.0
            newFrLb2.origin.x = baseFrame + 1.0 + 180.0 + 1.0
            newFrLb3.origin.x = baseFrame + 1.0 + 180.0 + 70.0 + 1.0
            newFrLb1.origin.y = CGFloat(screenSize.size.height)/2.0 - yDiscount + 1.0
            newFrLb2.origin.y = CGFloat(screenSize.size.height)/2 - yDiscount + 1.0
            newFrLb3.origin.y = CGFloat(screenSize.size.height)/2 - yDiscount + 1.0
            
            self.nameLabels[index].frame = newFrLb1
            self.distanceLabels[index].frame = newFrLb2
            self.timeLabels[index].frame = newFrLb3
            
        }, completion: { finished in
            print("animation \(index) finished")
            self.lastLabelMoved = index
            self.labelMoving = -1
            if index <= self.cityBarBackgrounds.count-1 {
                if index != 0 {
                    self.accumulatedScore += self.gameVariables[index-1].score
                    //self.scoreLabel.text = "Score: \(self.accumulatedScore)"
                    
                    self.animateScore(time: 0.5, targetScore: self.gameVariables[index-1].score, callback: #selector(self.finishScoreAnimation(index:)), index: index)
                } else {
                    self.moveLabels(index: 1)
                }
                //self.moveLabels(index+1)
                
            }
        })
    }

    var timeElapsedScoreTimer = 0.0
    var accNumberScoreTimer = 0
    var callBackScoreTimer : Selector?
    @objc func changeScoreLabel(timer: Timer) {
        //print(accNumberScoreTimer)
        
        if let dict = timer.userInfo as? [String:AnyObject] {
            if let timeLimit = dict["time"] as? Double {
                //print("tE: \(timeElapsedScoreTimer)")
                
                if let addingScore = dict["target"] as? Int {
                    //print("adding \(Int(round(Double(addingScore)*0.01/timeLimit)))")
                    //print("subtr \(self.accumulatedScore - accNumberScoreTimer)")
                    if self.accumulatedScore - accNumberScoreTimer <= Int(round(Double(addingScore)*0.01/timeLimit)) {
                        accNumberScoreTimer = self.accumulatedScore
                    } else {
                        accNumberScoreTimer += Int(round(Double(addingScore)*0.01/timeLimit))
                    }
                        
                    scoreLabel.text = "Score: \(accNumberScoreTimer)"
                        
                        
                }
                
                if timeElapsedScoreTimer > timeLimit {
                    if let scoreIndex = dict["index"] as? Int {
                        //print("se todo mundo sambasse... \(scoreIndex)")
                        scoreLabel.text = "Score: \(self.accumulatedScore)"
                        
                        if let selector = callBackScoreTimer {
                            Thread.detachNewThreadSelector(selector, toTarget: self, with: NSNumber(value:scoreIndex))
                            callBackScoreTimer = nil
                            timer.invalidate()
                            timeElapsedScoreTimer = 0.0
                        }
                        
                        
                        
                        
                        
                        //accNumberScoreTimer = 0
                    }
                }
            }
        }
        timeElapsedScoreTimer += 0.01
    }
    
    func animateScore(time: Double, targetScore: Int, callback: Selector? = nil, index: Int) {
        print("greg duv \(index)")
        print("acc score \(self.accumulatedScore)")
        
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.changeScoreLabel(timer:)), userInfo: ["time":time as Any, "target":targetScore as Any, "index":index as Any], repeats: true)
        
        callBackScoreTimer = callback
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
}
