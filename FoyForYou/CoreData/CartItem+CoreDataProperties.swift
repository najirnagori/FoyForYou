//
//  CartItem+CoreDataProperties.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 20/08/25.
//
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var dateAdded: Date
    @NSManaged public var id: UUID
    @NSManaged public var quantity: Int32
    @NSManaged public var product: Product
    @NSManaged public var user: User

}

extension CartItem : Identifiable {

}
