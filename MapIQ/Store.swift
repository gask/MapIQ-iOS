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

class Store: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var userCoins: UILabel!
    override func viewDidAppear(animated: Bool) {
        println("viewDidAppear")
        userCoins.text = String(AppDelegate.userCoins) + " coins"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("productsArrayCount: \(AppDelegate.productsArray.count)")
        return AppDelegate.productsArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("indexPath: \(indexPath.item)")
        AppDelegate.buyProduct(indexPath)
        //buyProduct(indexPath)
        //self.performSegueWithIdentifier("ThemeSelected", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("storeCell") as! StoreCell
        
        var product = AppDelegate.productsArray[indexPath.row]
        cell.tag = indexPath.row
        cell.itemName.text = product.localizedTitle
        //cell.flagImage.image = UIImage(named: "\(theme.mapCode)\(theme.order)")
        //cell.tag = indexPath.row
        //cell.themeName.text = theme.name
        
        return cell
    }
}




