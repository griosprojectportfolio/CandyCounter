//
//  AppDelegate.swift
//  Candy_Counter
//
//  Created by GrepRuby3 on 29/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        MagicalRecord.setupCoreDataStack()
        self.resetTablesInCoreData()
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.CandyCounter.apps.Candy_Counter" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Candy_Counter", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Candy_Counter.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    

    // MARK: - Reset Candy Table
    
    var isDBSetUpped : Bool {
        get {
            var strCurrentUser : Bool = false
            if(NSUserDefaults.standardUserDefaults().objectForKey("isSet") != nil){
                strCurrentUser = NSUserDefaults.standardUserDefaults().objectForKey("isSet") as! Bool
            }
            return strCurrentUser
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "isSet")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func resetTablesInCoreData(){
        
        if !isDBSetUpped {
            
            isDBSetUpped = true
            
            var arrData : NSMutableArray = [
                
                // Page 1
                ["candy_id" : 1, "candy_name":"candy_Aero", "candy_img":"candy_Aero", "candy_count":0],
                ["candy_id" : 2, "candy_name":"candy_Airheads", "candy_img":"candy_Airheads", "candy_count":0],
                ["candy_id" : 3, "candy_name":"candy_AlmondJoy", "candy_img":"candy_AlmondJoy", "candy_count":0],
                ["candy_id" : 4, "candy_name":"candy_AndesMints", "candy_img":"candy_AndesMints", "candy_count":0],
                
                ["candy_id" : 5, "candy_name":"candy_BabyRuth", "candy_img":"candy_BabyRuth", "candy_count":0],
                ["candy_id" : 6, "candy_name":"candy_Bazooka", "candy_img":"candy_Bazooka", "candy_count":0],
                ["candy_id" : 7, "candy_name":"candy_BitOHoney", "candy_img":"candy_BitOHoney", "candy_count":0],
                ["candy_id" : 8, "candy_name":"candy_BostonBakedBeans", "candy_img":"candy_BostonBakedBeans", "candy_count":0],
                
                ["candy_id" : 9, "candy_name":"candy_BubbleYum", "candy_img":"candy_BubbleYum", "candy_count":0],
                ["candy_id" : 10, "candy_name":"candy_Bubblicious", "candy_img":"candy_Bubblicious", "candy_count":0],
                ["candy_id" : 11, "candy_name":"candy_Butterfinger", "candy_img":"candy_Butterfinger", "candy_count":0],
                ["candy_id" : 12, "candy_name":"candy_Cadbury", "candy_img":"candy_Cadbury", "candy_count":0],
                
                // Page 2
                ["candy_id" : 13, "candy_name":"candy_CandyCorn", "candy_img":"candy_CandyCorn", "candy_count":0],
                ["candy_id" : 14, "candy_name":"candy_Caramello", "candy_img":"candy_Caramello", "candy_count":0],
                ["candy_id" : 15, "candy_name":"candy_Certs-asstfruit", "candy_img":"candy_Certs-asstfruit", "candy_count":0],
                ["candy_id" : 16, "candy_name":"candy_Certs-cinn", "candy_img":"candy_Certs-cinn", "candy_count":0],
                
                ["candy_id" : 17, "candy_name":"candy_Certs-pepp", "candy_img":"candy_Certs-pepp", "candy_count":0],
                ["candy_id" : 18, "candy_name":"candy_Certs-spearmint", "candy_img":"candy_Certs-spearmint", "candy_count":0],
                ["candy_id" : 19, "candy_name":"candy_Certs-wintgreen", "candy_img":"candy_Certs-wintgreen", "candy_count":0],
                ["candy_id" : 20, "candy_name":"candy_CharlestonChew", "candy_img":"candy_CharlestonChew", "candy_count":0],
                
                ["candy_id" : 21, "candy_name":"candy_Chiclets", "candy_img":"candy_Chiclets", "candy_count":0],
                ["candy_id" : 22, "candy_name":"candy_ChocolateCoins", "candy_img":"candy_ChocolateCoins", "candy_count":0],
                ["candy_id" : 23, "candy_name":"candy_Chuckles", "candy_img":"candy_Chuckles", "candy_count":0],
                ["candy_id" : 24, "candy_name":"candy_ChupaChups", "candy_img":"candy_ChupaChups", "candy_count":0],
                
                // Page 3
                ["candy_id" : 25, "candy_name":"candy_ClarkBar", "candy_img":"candy_ClarkBar", "candy_count":0],
                ["candy_id" : 26, "candy_name":"candy_CrackerJack", "candy_img":"candy_CrackerJack", "candy_count":0],
                ["candy_id" : 27, "candy_name":"candy_Crunchie", "candy_img":"candy_Crunchie", "candy_count":0],
                ["candy_id" : 28, "candy_name":"candy_DippinStix", "candy_img":"candy_DippinStix", "candy_count":0],
                
                ["candy_id" : 29, "candy_name":"candy_Dots", "candy_img":"candy_Dots", "candy_count":0],
                ["candy_id" : 30, "candy_name":"candy_Dove", "candy_img":"candy_Dove", "candy_count":0],
                ["candy_id" : 31, "candy_name":"candy_DubbleBubble", "candy_img":"candy_DubbleBubble", "candy_count":0],
                ["candy_id" : 32, "candy_name":"candy_FerreroRocher", "candy_img":"candy_FerreroRocher", "candy_count":0],
                
                ["candy_id" : 33, "candy_name":"candy_FunDip", "candy_img":"candy_FunDip", "candy_count":0],
                ["candy_id" : 34, "candy_name":"candy_Ghirardelli", "candy_img":"candy_Ghirardelli", "candy_count":0],
                ["candy_id" : 35, "candy_name":"candy_Gobstopper", "candy_img":"candy_Gobstopper", "candy_count":0],
                ["candy_id" : 36, "candy_name":"candy_Godiva", "candy_img":"candy_Godiva", "candy_count":0],
            
                // Page 4
                ["candy_id" : 37, "candy_name":"candy_Goobers", "candy_img":"candy_Goobers", "candy_count":0],
                ["candy_id" : 38, "candy_name":"candy_GoodAndPlenty", "candy_img":"candy_GoodAndPlenty", "candy_count":0],
                ["candy_id" : 39, "candy_name":"candy_GummyBears", "candy_img":"candy_GummyBears", "candy_count":0],
                ["candy_id" : 40, "candy_name":"candy_Haribo", "candy_img":"candy_Haribo", "candy_count":0],
                
                ["candy_id" : 41, "candy_name":"candy_Heath", "candy_img":"candy_Heath", "candy_count":0],
                ["candy_id" : 42, "candy_name":"candy_HersheysBar", "candy_img":"candy_HersheysBar", "candy_count":0],
                ["candy_id" : 43, "candy_name":"candy_HersheysCookiesAndCream", "candy_img":"candy_HersheysCookiesAndCream", "candy_count":0],
                ["candy_id" : 44, "candy_name":"candy_HersheysKisses", "candy_img":"candy_HersheysKisses", "candy_count":0],
                
                ["candy_id" : 45, "candy_name":"candy_HersheysSymphony", "candy_img":"candy_HersheysSymphony", "candy_count":0],
                ["candy_id" : 46, "candy_name":"candy_HotTamales", "candy_img":"candy_HotTamales", "candy_count":0],
                ["candy_id" : 47, "candy_name":"candy_IceBreakers", "candy_img":"candy_IceBreakers", "candy_count":0],
                ["candy_id" : 48, "candy_name":"candy_JawBreaker", "candy_img":"candy_JawBreaker", "candy_count":0],
                
                //Page 5
                ["candy_id" : 49, "candy_name":"candy_JellyBeans", "candy_img":"candy_JellyBeans", "candy_count":0],
                ["candy_id" : 50, "candy_name":"candy_JellyBelly", "candy_img":"candy_JellyBelly", "candy_count":0],
                ["candy_id" : 51, "candy_name":"candy_JollyRancherHardCandy", "candy_img":"candy_JollyRancherHardCandy", "candy_count":0],
                ["candy_id" : 52, "candy_name":"candy_JuniorMints", "candy_img":"candy_JuniorMints", "candy_count":0],
                
                ["candy_id" : 53, "candy_name":"candy_Kinder", "candy_img":"candy_Kinder", "candy_count":0],
                ["candy_id" : 54, "candy_name":"candy_KitKat", "candy_img":"candy_KitKat", "candy_count":0],
                ["candy_id" : 55, "candy_name":"candy_Krackel", "candy_img":"candy_Krackel", "candy_count":0],
                ["candy_id" : 56, "candy_name":"candy_LaffyTaffy", "candy_img":"candy_LaffyTaffy", "candy_count":0],
                
                ["candy_id" : 57, "candy_name":"candy_Lemonhead", "candy_img":"candy_Lemonhead", "candy_count":0],
                ["candy_id" : 58, "candy_name":"candy_LifeSavers", "candy_img":"candy_LifeSavers", "candy_count":0],
                ["candy_id" : 59, "candy_name":"candy_MMs", "candy_img":"candy_MMs", "candy_count":0],
                ["candy_id" : 60, "candy_name":"candy_MMsPeanut", "candy_img":"candy_MMsPeanut", "candy_count":0],
            
                //Page 6
                ["candy_id" : 61, "candy_name":"candy_MambaFruitChews", "candy_img":"candy_MambaFruitChews", "candy_count":0],
                ["candy_id" : 62, "candy_name":"candy_Mars", "candy_img":"candy_Mars", "candy_count":0],
                ["candy_id" : 63, "candy_name":"candy_Mentos", "candy_img":"candy_Mentos", "candy_count":0],
                ["candy_id" : 64, "candy_name":"candy_MikeAndIke", "candy_img":"candy_MikeAndIke", "candy_count":0],
                
                ["candy_id" : 65, "candy_name":"candy_MilkDuds", "candy_img":"candy_MilkDuds", "candy_count":0],
                ["candy_id" : 66, "candy_name":"candy_MilkyWay", "candy_img":"candy_MilkyWay", "candy_count":0],
                ["candy_id" : 67, "candy_name":"candy_Mounds", "candy_img":"candy_Mounds", "candy_count":0],
                ["candy_id" : 68, "candy_name":"candy_mrGoodbar", "candy_img":"candy_mrGoodbar", "candy_count":0],
                
                ["candy_id" : 69, "candy_name":"candy_Nerds", "candy_img":"candy_Nerds", "candy_count":0],
                ["candy_id" : 70, "candy_name":"candy_nestleChunky", "candy_img":"candy_nestleChunky", "candy_count":0],
                ["candy_id" : 71, "candy_name":"candy_NestleCrunch", "candy_img":"candy_NestleCrunch", "candy_count":0],
                ["candy_id" : 72, "candy_name":"candy_NowAndLater", "candy_img":"candy_NowAndLater", "candy_count":0],
                
                // Page 7
                ["candy_id" : 73, "candy_name":"candy_OhHenry", "candy_img":"candy_OhHenry", "candy_count":0],
                ["candy_id" : 74, "candy_name":"candy_PayDay", "candy_img":"candy_PayDay", "candy_count":0],
                ["candy_id" : 75, "candy_name":"candy_Pez", "candy_img":"candy_Pez", "candy_count":0],
                ["candy_id" : 76, "candy_name":"candy_PixyStix", "candy_img":"candy_PixyStix", "candy_count":0],
                
                ["candy_id" : 77, "candy_name":"candy_PlantersNuts", "candy_img":"candy_PlantersNuts", "candy_count":0],
                ["candy_id" : 78, "candy_name":"candy_PopRocks", "candy_img":"candy_PopRocks", "candy_count":0],
                ["candy_id" : 79, "candy_name":"candy_ReesesPBCups", "candy_img":"candy_ReesesPBCups", "candy_count":0],
                ["candy_id" : 80, "candy_name":"candy_Rolo", "candy_img":"candy_Rolo", "candy_count":0],
                
                ["candy_id" : 81, "candy_name":"candy_Skittles", "candy_img":"candy_Skittles", "candy_count":0],
                ["candy_id" : 82, "candy_name":"candy_Skor", "candy_img":"candy_Skor", "candy_count":0],
                ["candy_id" : 83, "candy_name":"candy_SkyBar", "candy_img":"candy_SkyBar", "candy_count":0],
                ["candy_id" : 84, "candy_name":"candy_Smarties", "candy_img":"candy_Smarties", "candy_count":0],
                
                // Page 8
                ["candy_id" : 85, "candy_name":"candy_Snickers", "candy_img":"candy_Snickers", "candy_count":0],
                ["candy_id" : 86, "candy_name":"candy_SourPatchKids", "candy_img":"candy_SourPatchKids", "candy_count":0],
                ["candy_id" : 87, "candy_name":"candy_Spree", "candy_img":"candy_Spree", "candy_count":0],
                ["candy_id" : 88, "candy_name":"candy_Starburst", "candy_img":"candy_Starburst", "candy_count":0],
                
                ["candy_id" : 89, "candy_name":"candy_SugarDaddy", "candy_img":"candy_SugarDaddy", "candy_count":0],
                ["candy_id" : 90, "candy_name":"candy_SwedishFish", "candy_img":"candy_SwedishFish", "candy_count":0],
                ["candy_id" : 91, "candy_name":"candy_Sweetarts", "candy_img":"candy_Sweetarts", "candy_count":0],
                ["candy_id" : 92, "candy_name":"candy_Take5", "candy_img":"candy_Take5", "candy_count":0],
                
                ["candy_id" : 93, "candy_name":"candy_TicTac", "candy_img":"candy_TicTac", "candy_count":0],
                ["candy_id" : 94, "candy_name":"candy_Toblerone", "candy_img":"candy_Toblerone", "candy_count":0],
                ["candy_id" : 95, "candy_name":"candy_TootsieRoll", "candy_img":"candy_TootsieRoll", "candy_count":0],
                ["candy_id" : 96, "candy_name":"candy_TootsieRollPop", "candy_img":"candy_TootsieRollPop", "candy_count":0],
                
                //Page 9
                ["candy_id" : 97, "candy_name":"candy_TurkishTaffy-ban", "candy_img":"candy_TurkishTaffy-ban", "candy_count":0],
                ["candy_id" : 98, "candy_name":"candy_TurkishTaffy-choc", "candy_img":"candy_TurkishTaffy-choc", "candy_count":0],
                ["candy_id" : 99, "candy_name":"candy_TurkishTaffy-straw", "candy_img":"candy_TurkishTaffy-straw", "candy_count":0],
                ["candy_id" : 100, "candy_name":"candy_TurkishTaffy-vanilla", "candy_img":"candy_TurkishTaffy-vanilla", "candy_count":0],
                
                ["candy_id" : 101, "candy_name":"candy_Twix", "candy_img":"candy_Twix", "candy_count":0],
                ["candy_id" : 102, "candy_name":"candy_Twizzlers", "candy_img":"candy_Twizzlers", "candy_count":0],
                ["candy_id" : 103, "candy_name":"candy_Warheads", "candy_img":"candy_Warheads", "candy_count":0],
                ["candy_id" : 104, "candy_name":"candy_WelchsFruitSnacks", "candy_img":"candy_WelchsFruitSnacks", "candy_count":0],
                
                ["candy_id" : 105, "candy_name":"candy_WhatChaMaCallIt", "candy_img":"candy_WhatChaMaCallIt", "candy_count":0],
                ["candy_id" : 106, "candy_name":"candy_Whoppers", "candy_img":"candy_Whoppers", "candy_count":0],
                ["candy_id" : 107, "candy_name":"candy_WrigleysDoubleMint", "candy_img":"candy_WrigleysDoubleMint", "candy_count":0],
                ["candy_id" : 108, "candy_name":"candy_YorkPep", "candy_img":"candy_YorkPep", "candy_count":0]
            ]
            
            MagicalRecord.saveWithBlock({ (context : NSManagedObjectContext!) -> Void in
                Candy.entityFromArrayInContext(arrData,localContext:context)
            })
            
            print("Data Base successfully set up.")
            
        }else {
            print("Data Base already set up.")
        }
    }
    
    
}

