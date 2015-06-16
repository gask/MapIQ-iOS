//
//  Store.swift
//  MapIQ
//
//  Created by GUILHERME LANE on 5/30/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import Social

class Store: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var userCoinsLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        println("viewDidAppear")
        userCoinsLabel.text = String(AppDelegate.userCoins) + " coins"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "productWasBought", name: "boughtCoins", object: nil)
        
    }
    
    func productWasBought(){
        println("productWasBought")
        userCoinsLabel.text = String(AppDelegate.userCoins) + " coins"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("productsArrayCount: \(AppDelegate.productsArray.count)")
        return AppDelegate.productsArray.count + 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("indexPath: \(indexPath.row)")
        if(indexPath.row<5){
            AppDelegate.buyProduct(indexPath)
        }else{
            println("OpenFacebbok")
            var urlPage = NSURL(string: "https://www.facebook.com/pages/Map-IQ-Free-Quiz-Trivia-Community/548654631858059")
            UIApplication.sharedApplication().openURL(urlPage!)
        }
        
        //buyProduct(indexPath)
        //self.performSegueWithIdentifier("ThemeSelected", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("index: \(indexPath.row)")
        var cell = tableView.dequeueReusableCellWithIdentifier("storeCell") as! StoreCell
        if(indexPath.row<5){
            var product = AppDelegate.productsArray[indexPath.row]
            cell.itemName.text = product.localizedTitle
        }else{
            cell.itemName.text = "Like Us On Facebook"
        }
        cell.tag = indexPath.row
        
        //cell.flagImage.image = UIImage(named: "\(theme.mapCode)\(theme.order)")
        //cell.tag = indexPath.row
        //cell.themeName.text = theme.name
        
        return cell
    }
}




