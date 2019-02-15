//
//  SessionManager.swift
//  Task
//
//  Created by Sumit Ghosh on 15/02/19.
//  Copyright © 2019 Sumit Ghosh. All rights reserved.
//

import Foundation


class SessionManager {
    static let sharedInstance = SessionManager()
    
    //Get Request 
    func getRequest(with url: URL, completionHandler: @escaping (Data?, Error?) -> Void) -> Void {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        //Created url session for getting data from the API 
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                completionHandler(nil, error)
                return
            }
            
            let httpResponse: HTTPURLResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 200 {
                
                completionHandler(data, nil)
            }
            else {
                completionHandler(nil, error)
            }
            }.resume()
    }
}
