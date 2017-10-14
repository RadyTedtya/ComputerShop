//
//  ProductTableViewController.swift
//  ComputerShop
//
//  Created by Tedtya on 10/2/17.
//  Copyright © 2017 Tedtya. All rights reserved.
//

import UIKit

class ProductTableViewController: UITableViewController {
    
    var products = [Product]()
    var getBrand:String!
    var getType:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadProduct()
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            let getCell = sender as! UITableViewCell
            let index = tableView.indexPath(for: getCell)
        
            let getName = products[index!.row].name
            let getPrice = products[index!.row].price
            let getModel = products[index!.row].model
            let getImage = products[index!.row].imageUrl
            let getDescription = products[index!.row].description
        
            let nextVC = segue.destination as! SingleProductViewController
        
            nextVC.getName = getName
            nextVC.getModel = getModel
            nextVC.getPrice = getPrice
            nextVC.getImage = getImage
            nextVC.getDescription = getDescription
    
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product_cell") as! ProductTableViewCell
        let pro = products[indexPath.row]
        cell.productName?.text = pro.name
        cell.productPrice?.text = ("Price : ")+pro.price+"$"
        cell.productModel?.text = ("Model : ")+pro.model
        
        if pro.imageUrl.isEmpty{
            cell.productImageView.image = #imageLiteral(resourceName: "ic_broken_image")
        }else{
        
        let imageURL = URL(string: pro.imageUrl)!
        
            let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                let img = UIImage(data: data!)
                DispatchQueue.main.async {
                        cell.productImageView?.image = img
                }
                
                
            }
            task.resume()
        }
        return cell
    }
    
    func loadProduct(){
        let productUrl = URL(string: "http://localhost:8888/ComputerShop/getProduct.php?Type=\(getType!)&Brand=\(getBrand!)")
        let task = URLSession.shared.dataTask(with: productUrl!) { (data, response, error) in
            
            if error != nil {
                print("ERROR",error!.localizedDescription)
            }else{
                DispatchQueue.main.async {
                    self.deserializeData(data!)
                }
            }
        }
        task.resume()
    }
    
    func deserializeData(_ data: Data){
        var productFromServer = [Product]()
        let items = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        for item in items{
            let proDict = item as! [String:Any]
            let name = proDict["name"] as! String
            let model = proDict["model"] as! String
            let price = proDict["price"] as! String
            let image = proDict["image"] as! String
            let description = proDict["description"] as! String
    
//            let pro = Product(name: name, model: model, price: price, imageUrl: image, description: description)
            let pro = Product(name: name, model: model, price: price, imageUrl: image, description: description)
            productFromServer.append(pro)
        }
        products = productFromServer
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}





