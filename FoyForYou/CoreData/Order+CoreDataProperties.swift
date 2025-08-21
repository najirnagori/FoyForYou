//
//  Order+CoreDataProperties.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 20/08/25.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var shippingAddress: String?
    @NSManaged public var status: String?
    @NSManaged public var totalAmount: Double
    @NSManaged public var cartItem: NSSet?
    @NSManaged public var user: User

}

// MARK: Generated accessors for cartItem
extension Order {

    @objc(addCartItemObject:)
    @NSManaged public func addToCartItem(_ value: CartItem)

    @objc(removeCartItemObject:)
    @NSManaged public func removeFromCartItem(_ value: CartItem)

    @objc(addCartItem:)
    @NSManaged public func addToCartItem(_ values: NSSet)

    @objc(removeCartItem:)
    @NSManaged public func removeFromCartItem(_ values: NSSet)

}

extension Order : Identifiable {

}
