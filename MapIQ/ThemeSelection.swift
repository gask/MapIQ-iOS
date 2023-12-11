//
//  ThemeSelection.swift
//  MapIQ
//
//  Created by Francisco F Neto on 21/04/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import UIKit

class ThemeSelection: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private var _plistFile: [String:NSObject]?
    var plistFile: [String:NSObject] {
        if _plistFile == nil {
            if let plistPath = Bundle.main.path(forResource: "locales", ofType: "plist") {
                if let dict = NSDictionary(contentsOfFile: plistPath) as? [String: NSObject] {
                    _plistFile = dict
                }
            }
        }
        
        if _plistFile == nil {
            print("something went wrong reading contents of locales plist")
            _plistFile = [String:NSObject]()
        }
        
        return _plistFile!
    }
    
    var themeArray = [Theme]()
    
    override func viewDidLoad() {
        
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if let tArray = self.plistFile["themes"] as? [NSDictionary]{
            for tmpTheme in tArray {
                //println("theme: \(tmpTheme)")
                let ptUn = tmpTheme["pointsToUnlock"] as! Int
                let ord = tmpTheme["order"] as! Int
                let theme = Theme(ID: tmpTheme["ID"] as! Int, name: tmpTheme["name"] as! String, mapCode: tmpTheme["mapCode"] as! String, parentTheme: tmpTheme["parent"] as! Int, unlockPts: ptUn, tOrder: ord)
                
                if let lArray = tmpTheme["locales"] as? [NSDictionary] {
                    var larr = [Locale]()
                    for locValue in lArray {
                        let locale = Locale(ID: locValue["localeID"] as! Int, latitude: ((locValue["latitude"] as! String) as NSString).doubleValue, longitude: ((locValue["longitude"] as! String) as NSString).doubleValue, name: locValue["localeName"] as! String)
                        larr.append(locale)
                    }
                    theme.locales = larr
                    themeArray.append(theme)
                }
                
            }
        }
        
        
        
        //println("temas: \(themeArray)")
        //println("temas[1]: \(themeArray[1])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ThemeSelected", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath)
        
        let theme = themeArray[indexPath.row]
        
        if let c = cell as? ThemeCell {
            c.flagImage.image = UIImage(named: "\(theme.mapCode)\(theme.order)")
            c.tag = indexPath.row
            c.themeName.text = theme.name
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ThemeSelected" {
            guard let selectedIndex = sender as? Int else { return }
            
            print("selectedIndex: \(selectedIndex)")
            
            guard let vc = segue.destination as? Game else { return }
            
            var tArr = [Locale]()
            let places = themeArray[selectedIndex]
            print("places: \(places)")
            for i in 0...4 {
                let pl = places.locales[i]
                tArr.append(pl)
            }
            
            vc.rightArray = tArr
            vc.mapName = places.mapCode
        }
    }
    
}

