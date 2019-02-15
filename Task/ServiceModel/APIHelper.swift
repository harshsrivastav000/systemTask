//
//  APIHelper.swift
//  Task
//
//  Created by Sumit Ghosh on 15/02/19.
//  Copyright © 2019 Sumit Ghosh. All rights reserved.
//

import Foundation
import UIKit

class APIHelper: NSObject {
    static let sharedInstance = APIHelper()
    
    //MARK: get data from API 
    func getAllData(completionHandler: @escaping([response_data]?, Error?) -> Void) -> Void{
        
        let url = URL(string: "\(NetworkConfigurations.BASE_URL)posts")
    
        SessionManager.sharedInstance.getRequest(with: url!) { (data, error) in
            if error != nil {
                completionHandler(nil, error)
            }
            else {
                do {
                    let response = try JSONDecoder().decode([response_data].self, from: data! as Data)
                    completionHandler(response, error)
                } catch let error {
                    print(error)
                }
            }
        }
    }
}
