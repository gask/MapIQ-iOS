//
//  Game.swift
//  MapIQ
//
//  Created by Francisco F Neto on 21/04/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import UIKit

class Game: UIViewController {
    
    @IBOutlet var gameMap: GMSMapView!
    @IBOutlet var placeName: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    var timer: NSTimer!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("bleu"), userInfo: nil, repeats: true)
    }

    func bleu() -> Bool! {
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

