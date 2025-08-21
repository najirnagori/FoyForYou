//
//  User+CoreDataProperties.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 20/08/25.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var password: String
    @NSManaged public var userImage: Data?
    @NSManaged public var userName: String

}

extension User : Identifiable {

}
