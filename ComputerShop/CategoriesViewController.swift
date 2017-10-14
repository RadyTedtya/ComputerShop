//
//  CategoriesViewController.swift
//  ComputerShop
//
//  Created by Tedtya on 9/13/17.
//  Copyright © 2017 Tedtya. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var types = [Typee]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadCategories()
        
        print()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categories_cell") as! CategoriesTableViewCell
        
        
        let type = types[indexPath.row]
        cell.categoriesName?.text = type.name
        
//        cell.imageView?.image = #imageLiteral(resourceName: "ic_image")
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let getCell = sender as! UITableViewCell
        let index = tableView.indexPath(for: getCell)
        
        let getType = types[index!.row].name
        let nextViewController = segue.destination as! BrandTableViewController
        nextViewController.getType = getType
        
        
    }
    
    
    
    
    func loadCategories(){
        let categoryUrl = URL(string: "http://localhost:8888/ComputerShop/getCategory.php")!
        
        let task = URLSession.shared.dataTask(with: categoryUrl) { (data, response, error) in
            if error != nil{
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
        var typeFromServer = [Typee]()
        let items = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        for item in items{
            let categoryDict = item as! [String:Any]
            let name = categoryDict["type"] as! String
        
            let typee = Typee(name: name )
            typeFromServer.append(typee)
            
        }
        
        types = typeFromServer
        tableView.reloadData()
    }

}
