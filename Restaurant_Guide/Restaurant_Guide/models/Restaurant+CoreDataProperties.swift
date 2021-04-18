//
//  Restaurant+CoreDataProperties.swift
//  Restaurant_Guide
//
//  Created by Jes Muli on 2021-04-15.
//
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var desc: String?
    @NSManaged public var name: String?
    @NSManaged public var postal_code: String?
    @NSManaged public var rating: String?
    @NSManaged public var street: String?
    @NSManaged public var tag: String?
    @NSManaged public var id: String?
    @NSManaged public var phone: String?

}

extension Restaurant : Identifiable {

}
