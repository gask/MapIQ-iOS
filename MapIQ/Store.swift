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

class Store: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var userCoinsLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        userCoinsLabel.text = String(AppDelegate.userCoins) + " coins"
        NotificationCenter.default.addObserver(self, selector: #selector(self.productWasBought), name: NSNotification.Name("boughtCoins"), object: nil)
    }
    
    @objc func productWasBought(){
        print("productWasBought")
        userCoinsLabel.text = String(AppDelegate.userCoins) + " coins"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("productsArrayCount: \(AppDelegate.productsArray.count)")
        return AppDelegate.productsArray.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath: \(indexPath.row)")
        if(indexPath.row<5){
            AppDelegate.buyProduct(sender: indexPath)
            return
        }
        
        print("OpenFacebbok")
        if let urlPage = URL(string: "https://www.facebook.com/pages/Map-IQ-Free-Quiz-Trivia-Community/548654631858059") {
            UIApplication.shared.open(urlPage)
        }
        
        //buyProduct(indexPath)
        //self.performSegueWithIdentifier("ThemeSelected", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("index: \(indexPath.row)")
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath)
        
        if let c = cell as? StoreCell {
            c.tag = indexPath.row
            
            if indexPath.row < 5 {
                let product = AppDelegate.productsArray[indexPath.row]
                c.itemName.text = product.localizedTitle
            } else {
                c.itemName.text = "Like Us On Facebook"
            }
        }
        
        
        
        //cell.flagImage.image = UIImage(named: "\(theme.mapCode)\(theme.order)")
        //cell.tag = indexPath.row
        //cell.themeName.text = theme.name
        
        return cell
    }
}




