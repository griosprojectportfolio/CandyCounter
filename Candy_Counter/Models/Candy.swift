//
//  Candy.swift
//  Candy_Counter
//
//  Created by GrepRuby3 on 02/10/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import CoreData

class Candy: NSManagedObject {

    @NSManaged var candy_count: NSNumber
    @NSManaged var candy_id: NSNumber
    @NSManaged var candy_img: String
    @NSManaged var candy_name: String
    
    
    class func findOrCreateByIDInContext(anID : NSNumber , localContext : NSManagedObjectContext) -> Candy {
        
        if let objUser : Candy = Candy.MR_findFirstByAttribute("candy_id", withValue: anID, inContext: localContext) {
            return objUser
        }else{
            let objUser : Candy = Candy.MR_createEntityInContext(localContext)
            return objUser
        }
    }
    
    class func entityFromArrayInContext(aArray : NSArray , localContext : NSManagedObjectContext){
        for aDictionary in aArray {
            Candy.entityFromDictionaryInContext(aDictionary as! NSDictionary, localContext: localContext)
        }
    }
    
    class func entityFromDictionaryInContext(aDictionary : NSDictionary, localContext : NSManagedObjectContext){
        
        if let candy_id : Int = aDictionary["candy_id"] as? Int {
            
            var objCandy : Candy = Candy.findOrCreateByIDInContext( candy_id , localContext: localContext)
            
            objCandy.candy_id = candy_id
            
            if let candy_name : String = aDictionary["candy_name"] as? String {
                objCandy.candy_name = candy_name
            }
            
            if let candy_img : String = aDictionary["candy_img"] as? String {
                objCandy.candy_img = candy_img
            }
            
            if let candy_count : Int = aDictionary["candy_count"] as? Int {
                objCandy.candy_count = candy_count
            }
        }
        
    }
    
}