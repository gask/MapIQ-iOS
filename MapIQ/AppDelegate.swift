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
        print("requestProductData")
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers:
                self.productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            print("cantMakePayments")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("productsRequest")
        
        let products = response.products
        
        if products.count == 0 {
            print("No products found")
        }
        
        for product in products {
            
            self.product = product
            print(product.price)
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            AppDelegate.productsArray.append(product)
        }
        //self.tableView.reloadData()
        
        for product in products {
            print("Product not found: \(product)")
        }
    }
    
    static func buyProduct(sender:IndexPath){
        print("buyProduct")
        let payment = SKPayment(product: AppDelegate.productsArray[sender.item])
        SKPaymentQueue.default().add(payment)
        AppDelegate.userCoins += 17
        print("userCoins: \(AppDelegate.userCoins)")
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //NSNotificationCenter.defaultCenter().addObserver(appDelegate, selector: "updateNotificationSentLabel", name: "boughtCoins", object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("boughtCoins"), object: nil)
    }
    
    func updateNotificationSentLabel(){
        print("updateNotificationSentLabel")
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        print("paymentQueue")
        for transaction in transactions as! [SKPaymentTransaction] {
            
            switch transaction.transactionState {
                
            case .purchased:
                print("Transaction Approved")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .failed:
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func deliverProduct(transaction:SKPaymentTransaction) {
        print("productIdentifiersCount: \(productIdentifiers.count)")
        for productIdentifier in productIdentifiers{
            if(transaction.payment.productIdentifier == productIdentifier){
                print("product: \(transaction.payment.productIdentifier)")
            }
        }
        
        /*
        if transaction.payment.productIdentifier == "com.brianjcoleman.testiap1"
        {
        print("Consumable Product Purchased")
        // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com.brianjcoleman.testiap2"
        {
        print("Non-Consumable Product Purchased")
        // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com.brianjcoleman.testiap3"
        {
        print("Auto-Renewable Subscription Product Purchased")
        // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com.brianjcoleman.testiap4"
        {
        print("Free Subscription Product Purchased")
        // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com.brianjcoleman.testiap5"
        {
        print("Non-Renewing Subscription Product Purchased")
        // Unlock Feature
        }*/
    }
    
    //let googleMapsApiKey = "AIzaSyAVZd6AZ6DR_Jv4nc8wANr5FvPFyez2-z0"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        requestProductData()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

