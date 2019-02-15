//
//  DataModel.swift
//  Task
//
//  Created by Sumit Ghosh on 15/02/19.
//  Copyright © 2019 Sumit Ghosh. All rights reserved.
//

import Foundation

//PARSE model for response 
struct response_data: Decodable {
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
}
