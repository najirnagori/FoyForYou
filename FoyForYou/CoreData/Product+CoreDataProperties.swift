//
//  Product+CoreDataProperties.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 20/08/25.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: UUID
    @NSManaged public var imageName: String?
    @NSManaged public var name: String
    @NSManaged public var price: Double
    @NSManaged public var productDescription: String?

}

extension Product : Identifiable {

}
