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

class Store: UIViewController, SKProductsRequestDelegate {
    
    var tableView = UITableView()
    let productIdentifiers = Set(["com.brianjcoleman.testiap1", "com.brianjcoleman.testiap2", "com.brianjcoleman.testiap3", "com.brianjcoleman.testiap4", "com.brianjcoleman.testiap5"])
    var product: SKProduct?
    var productsArray = Array<SKProduct>()
    
    func requestProductData()
    {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers:
                self.productIdentifiers as Set<NSObject>)
            request.delegate = self
            request.start()
        } else {
            var alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.sharedApplication().openURL(url!)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        
        var products = response.products
        
        if (products.count != 0) {
            for var i = 0; i < products.count; i++
            {
                self.product = products[i] as? SKProduct
                self.productsArray.append(product!)
            }
            self.tableView.reloadData()
        } else {
            println("No products found")
        }
        
        products = response.invalidProductIdentifiers
        
        for product in products
        {
            println("Product not found: \(product)")
        }
    }
}




