//
//  Post+CoreDataProperties.swift
//  Task
//
//  Created by Harsh Srivastava on 15/02/19.
//  Copyright © 2019 Sumit Ghosh. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var userId: Int16
    @NSManaged public var id: Int16
    @NSManaged public var body: String?
    @NSManaged public var title: String?

}
