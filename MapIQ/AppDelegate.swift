//
//  AppDelegate.swift
//  MapIQ
//
//  Created by Francisco F Neto on 21/04/15.
//  Copyright (c) 2015 giovannibf. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SKProductsRequestDelegate{
    
    var window: UIWindow?
    let productIdentifiers = Set(["com.giovannibf.mapquiz.1000coinspack", "com.giovannibf.mapquiz.10000coinspack", "com.giovannibf.mapquiz.2500coinspack", "com.giovannibf.mapquiz.4000coinspack", "com.giovannibf.mapquiz.ingamehint"])
    var product: SKProduct?
    static var productsArray = Array<SKProduct>()
    static var userCoins = 5
    func requestProductData(){
        println("requestProductData")
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers:
                self.productIdentifiers as Set<NSObject>)
            request.delegate = self
            request.start()
        } else {
            println("cantMakePayments")
        }
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        println("productsRequest")
        var products = response.products
        
        if (products.count != 0) {
            for var i = 0; i < products.count; i++
            {
                self.product = products[i] as? SKProduct
                println(product?.price)
                println(product?.productIdentifier)
                println(product?.localizedTitle)
                println(product?.localizedDescription)
                AppDelegate.productsArray.append(product!)
                
            }
            //self.tableView.reloadData()
        } else {
            println("No products found")
        }
        
        products = response.invalidProductIdentifiers
        
        for product in products
        {
            println("Product not found: \(product)")
        }
    }
    
    static func buyProduct(sender:NSIndexPath){
        println("buyProduct")
        let payment = SKPayment(product: AppDelegate.productsArray[sender.item])
        SKPaymentQueue.defaultQueue().addPayment(payment)
        AppDelegate.userCoins += 17
        println("userCoins: \(AppDelegate.userCoins)")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //NSNotificationCenter.defaultCenter().addObserver(appDelegate, selector: "updateNotificationSentLabel", name: "boughtCoins", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("boughtCoins", object: nil)
        
    }
    
    func updateNotificationSentLabel(){
        println("updateNotificationSentLabel")
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        println("paymentQueue")
        for transaction in transactions as! [SKPaymentTransaction] {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.Purchased:
                println("Transaction Approved")
                println("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction)
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
            case SKPaymentTransactionState.Failed:
                println("Transaction Failed")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func deliverProduct(transaction:SKPaymentTransaction) {
        println("productIdentifiersCount: \(productIdentifiers.count)")
        for productIdentifier in productIdentifiers{
            if(transaction.payment.productIdentifier == productIdentifier){
                println("product: \(transaction.payment.productIdentifier)")
            }
        }
        
        /*
        if transaction.payment.productIdentifier == "com.brianjcoleman.testiap1"
        {
        println("Consumable Product Purchased")
        // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com.brianjcoleman.testiap2"
        {
        println("Non-Consumable Product Purchased")
        // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com.brianjcoleman.testiap3"
        {
        println("Auto-Renewable Subscription Product Purchased")
        // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com.brianjcoleman.testiap4"
        {
        println("Free Subscription Product Purchased")
        // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com.brianjcoleman.testiap5"
        {
        println("Non-Renewing Subscription Product Purchased")
        // Unlock Feature
        }*/
    }
    
    //let googleMapsApiKey = "AIzaSyAVZd6AZ6DR_Jv4nc8wANr5FvPFyez2-z0"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //GMSServices.provideAPIKey(googleMapsApiKey)
        requestProductData()
        FBLoginView.self
        FBProfilePictureView.self
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
}

