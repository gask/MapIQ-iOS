//
//  ThemeSelection.swift
//  MapIQ
//
//  Created by Francisco F Neto on 21/04/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import UIKit

class ThemeSelection: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let plistFile = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("locales", ofType: "plist")!)
    
    var themeArray = [Theme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let info = plistFile as? [String:NSObject] {
            if let tArray = info["themes"] as? [NSDictionary]{
                for tmpTheme in tArray {
                    var theme = Theme(ID: tmpTheme["ID"] as! Int, name: tmpTheme["name"] as! String, mapCode: tmpTheme["mapCode"] as! String, parentTheme: tmpTheme["parent"] as! Int)
                    
                    if let lArray = tmpTheme["locales"] as? [NSDictionary] {
                        var larr = [Locale]()
                        for locValue in lArray {
                            var locale = Locale(ID: locValue["localeID"] as! Int, latitude: ((locValue["latitude"] as! String) as NSString).doubleValue, longitude: ((locValue["longitude"] as! String) as NSString).doubleValue, name: locValue["localeName"] as! String)
                            larr.append(locale)
                        }
                        theme.locales = larr
                        themeArray.append(theme)
                    }
                    
                }
            }
        }
        
        
        //println("temas: \(themeArray)")
        println("temas[1]: \(themeArray[1])")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeArray.count
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ThemeSelected", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("themeCell") as! ThemeCell
        
        var theme = themeArray[indexPath.row]
        println("crazy fuck: \(indexPath)")
        
        cell.tag = indexPath.row
        cell.themeName.text = theme.name
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ThemeSelected" {
            var cell = sender as! ThemeCell
            
            println("cell ip: \(cell.tag)")
            
            var vc : Game = segue.destinationViewController as! Game
            
            var tArr = [Locale]()
            let places = themeArray[cell.tag]
            println("places: \(places)")
            for i in 0...4 {
                let pl = places.locales[i]
                tArr.append(pl)
            }
            
            vc.rightArray = tArr
            vc.mapName = places.mapCode
        }
    }
    
}

