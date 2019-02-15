//
//  DataViewModel.swift
//  Task
//
//  Created by Sumit Ghosh on 15/02/19.
//  Copyright © 2019 Sumit Ghosh. All rights reserved.
//

import UIKit

class DataViewModel: NSObject {
    var userID:Int16?
    var id:Int16?
    var title: String?
    var body: String?
    
    //Initialise method for view model contains parsing logic
    init(data:Post) {
        self.userID = data.userId
        self.id = data.id
        self.title = data.title ?? ""
        self.body = data.body ?? ""
    }
}


