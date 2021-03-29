//
//  CoreDataManager.swift
//  RestaurantGuide
//
//  Created by Tech on 2021-03-28.
//  Copyright © 2021 GBC. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    private class func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // store object into coredate
    class func storeObj(){
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "RestaurantEntity", in: context)
        
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue("Tim Hortons", forKey: "name")
        managedObj.setValue("2900 Warden Ave Unit 149", forKey: "street")
        managedObj.setValue("Scarborough", forKey: "city")
        managedObj.setValue("ON", forKey: "state")
        managedObj.setValue("M1W2SB", forKey: "postcode")
        managedObj.setValue("fast food", forKey: "tag")
        managedObj.setValue("good", forKey: "descriptions")
        managedObj.setValue(4167730663, forKey: "phone")
        managedObj.setValue(3.5, forKey: "rate")
        
        do{
            try context.save()
            print("saved!")
        }catch{
            print(error.localizedDescription)
        }
    }
    
    // fetch/load object from coredata
    class func fetchObj() -> [restaurantItem]{
        var array = [restaurantItem]()
        
        let fetchRequest:NSFetchRequest<RestaurantEntity> = RestaurantEntity.fetchRequest()
        
        do{
            let fetchResult = try getContext().fetch(fetchRequest)

            
            for item in fetchResult{
                let restaurant = restaurantItem(name:item.name!, street:item.street!, city:item.city!,
                               state:item.state!, postCode:item.postcode!, tag:item.tag!,
                               descriptions:item.descriptions!, phone:item.phone, rate:item.rate)
                
                array.append(restaurant)
                
                // print name in console
                print(restaurant.rName!)
            }
        }catch{
            print(error.localizedDescription)
        }
        
        return array
        
    }
}

// declare restaurant
struct restaurantItem{
    var rName:String?
    var rStreet:String?
    var rCity:String?
    var rState:String?
    var rPostCode:String?
    var rTag:String?
    var rDescriptions:String?
    var rPhone:Int32?
    var rRate:Float?
    
    init(){
        rName = ""
        rStreet = ""
        rCity = ""
        rState = ""
        rPostCode = ""
        rTag = ""
        rDescriptions = ""
        rPhone = 0000000000
        rRate = 0.0
    }
    
    init(name:String, street:String, city:String, state:String,
         postCode:String, tag:String, descriptions:String,
         phone:Int32, rate:Float){
        
        self.rName = name
        self.rStreet = street
        self.rCity = city
        self.rState = state
        self.rPostCode = postCode
        self.rTag = tag
        self.rDescriptions = descriptions
        self.rPhone = phone
        self.rRate = rate
    }
}
