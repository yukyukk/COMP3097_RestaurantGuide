//
//  ViewController.swift
//  RestaurantGuide
//
//  Created by Tech on 2021-03-28.
//  Copyright © 2021 GBC. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CoreDataManager.storeObj()
        
        
        CoreDataManager.fetchObj()
        
        // Do any additional setup after loading the view.
        
        
    }


}

