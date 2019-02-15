//
//  CoreDataHelper.swift
//  Task
//
//  Created by Harsh Srivastava on 15/02/19.
//  Copyright © 2019 Sumit Ghosh. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    
    static let sharedInstance = CoreDataHelper()

    //Initialise the persistant container
    //Persistant container encapsulates the Core Data stack in the application
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Add Data to the entity *row data
    func addTask(data:response_data) {
        
        let post = Post(context:context)
        post.userId = Int16(data.userId ?? 0)
        post.id = Int16(data.id ?? 0)
        post.title = data.title ?? ""
        post.body = data.body ?? ""
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    //Fetch all the entity from the attribute
    func fetch() -> Array<Post>{
        let finalArray:NSMutableArray = NSMutableArray.init()
        let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            for item in fetchedResults {
                finalArray .add(item)
            }
            return finalArray as! Array<Post>
        } catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
            return []
        }
    }
    
}



