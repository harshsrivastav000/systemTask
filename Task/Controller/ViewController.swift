//
//  ViewController.swift
//  Task
//
//  Created by Sumit Ghosh on 15/02/19.
//  Copyright © 2019 Sumit Ghosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // added refresh controll
    var refreshControl: UIRefreshControl!
    var dataArray = [DataViewModel]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createUI()
        self.getDataFromDataBase()
    }
    
    //MARK: create UI
    func createUI() -> Void {
        
        self.activityIndicator.isHidden = true
        
        //Added refresh control
        self.refreshControl = UIRefreshControl.init()
        self.refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = UIColor.gray
        self.dataTableView.addSubview(self.refreshControl)
        
        //Table properties
        self.dataTableView.estimatedRowHeight = 200
        self.dataTableView.rowHeight = UITableView.automaticDimension
        self.dataTableView.delegate = self
        self.dataTableView.dataSource = self
    }
    
    //MARK: Get Data from DB
    //check weather data is present in local storage or not
    func getDataFromDataBase() -> Void {
        let array = CoreDataHelper.sharedInstance.fetch()
        //Calling the viewmodel
        self.dataArray = array.map({DataViewModel.init(data: $0)})
        if self.dataArray.count == 0 {
            self.getDataFromApi()
        } else {
            self.dataTableView.reloadData()
        }
    }
    
    //MARK: Handle refresh control action
   @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getDataFromApi()
    }
    
    //MARK: Get Data form API
    func getDataFromApi() -> Void {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        APIHelper.sharedInstance.getAllData { (response, error) in
            DispatchQueue.main.async {[unowned self] in
                // end activity indicator
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                if error == nil {
                    let array = response ?? []
                    self.dataArray = self.saveToDataBaseAndMakeFinalArray(array: array)
                    self.dataTableView.reloadData()
                } else {
                    let alert = UIAlertController(title: "Sorry", message: "Something went worng please try again later", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
     
            }
        }
    }
    
    //MARK: Save data to Database
    func saveToDataBaseAndMakeFinalArray(array:[response_data]) -> [DataViewModel] {
        for data in array {
            if self.dataArray.count == 0 {
                CoreDataHelper.sharedInstance.addTask(data: data)
            } else {
                //Checking if data is exsisting or not
                if self.checkForExsistingData(data: data) {
                  // Do nothing
                } else {
                    CoreDataHelper.sharedInstance.addTask(data: data)
                }
            }
        }
        
        let array = CoreDataHelper.sharedInstance.fetch()
        //Passing the data to viewModel
        let finalArray = array.map({DataViewModel.init(data: $0)})
        
        return finalArray
        
    }
    
    //MARK: Check if data is exsisting or not
    func checkForExsistingData(data:response_data) -> Bool {
        let result = self.dataArray.contains { (dbData) -> Bool in
            let id = Int16(data.id ?? 0)
            if id == dbData.id {
                return true
            } else {
                return false
            }
        }
        return result
    }

}

//MARK: tableView delegates and datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        let data = self.dataArray[indexPath.row]
        cell.titleLabel.text = data.title ?? ""
        cell.bodyLabel.text =  data.body ?? ""
        
        return cell
    }
}
