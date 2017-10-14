//
//  CollectionViewController.swift
//  ComputerShop
//
//  Created by Tedtya on 10/4/17.
//  Copyright © 2017 Tedtya. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource {

    var types = [Typee]()
    
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.dataSource = self
        collectionview.dataSource = self
        loadCategories()
        
        print()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_collection", for: indexPath) as! colCollectionViewCell
        
        
        let type = types[indexPath.row]
        cell.Label?.text = type.name
        return cell
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
            //            let image = categoryDict["_content"] as! String
            
            let typee = Typee(name: name )
            typeFromServer.append(typee)
            
        }
        
        types = typeFromServer
        collectionview.reloadData()
    }
    

    
  
}
