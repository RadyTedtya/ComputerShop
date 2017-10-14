//
//  SingleProductViewController.swift
//  ComputerShop
//
//  Created by Tedtya on 10/4/17.
//  Copyright © 2017 Tedtya. All rights reserved.
//

import UIKit

class SingleProductViewController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
 
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productModel: UILabel!
    
    
    var getName:String = ""
    var getModel:String = ""
    var getPrice:String = ""
    var getImage:String = ""
    var getDescription:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productName.text = getName
        productModel.text = ("Model : ")+getModel
        productPrice.text = getPrice+"$"
        productDescription.text = getDescription
        
        
        if getImage.isEmpty{
            self.productImageView.image = #imageLiteral(resourceName: "ic_broken_image")
        }else{
        
        let imageURL = URL(string: getImage)!
        
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            let img = UIImage(data: data!)
            DispatchQueue.main.async {
                    self.productImageView.image = img
            }
            
   
        }
        task.resume()
        
        }
    }
    
    
}
