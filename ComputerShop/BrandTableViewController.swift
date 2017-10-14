//
//  BrandTableViewController.swift
//  ComputerShop
//
//  Created by Tedtya on 9/16/17.
//  Copyright © 2017 Tedtya. All rights reserved.
//

import UIKit

class BrandTableViewController: UITableViewController {
    var brands = [Brand]()
    var getType:String!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadBrand()
    }
    
    func loadBrand(){
        let brandUrl = URL(string: "http://localhost:8888/ComputerShop/getType.php?Type="+getType)!
        print(brandUrl)
        let task = URLSession.shared.dataTask(with: brandUrl) { (data, response, error) in
        
            if error != nil {
                print("Error",error!.localizedDescription)
            }else{
                DispatchQueue.main.async {
                    self.deserializeData(data!)
                }
            }
            
        }
        task.resume()
    }

    func deserializeData(_ data: Data) {
        var brandFromserver = [Brand]()
        let items = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        for item in items{
            let brandDict = item as! [String:Any]
            let name = brandDict["brand"] as! String
            
            let brand = Brand(name: name)
            brandFromserver.append(brand)
            
        }
        brands = brandFromserver
        self.tableView.reloadData()
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "brand_cell") as! BrandTableViewCell
        let brandd = brands[indexPath.row]
        
//        cell.textLabel?.text = brandd.name
        cell.brandName?.text = brandd.name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let getCell = sender as! UITableViewCell
        let index = tableView.indexPath(for: getCell)
        
        let getBrand = brands[index!.row].name
        let nextVC = segue.destination as! ProductTableViewController
        nextVC.getBrand = getBrand
        nextVC.getType = getType
        
        
    }


}
