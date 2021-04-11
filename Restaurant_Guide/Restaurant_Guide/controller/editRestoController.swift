//
//  editRestoController.swift
//  Restaurant_Guide
//
//  Created by Lei Jing, Jes Muli, Daniel Lee on 2021-04-10.
//

import Foundation
import UIKit
import CoreData


class editRestoController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[Restaurant]?
    var editIndex = ""
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPostal: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var tagBtnDropped: UIButton!
    @IBOutlet weak var tagTblView: UITableView!
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet var starRating: [UIButton]!
    var resto_rating: String = "0"
    var resto_tag: String = "Others"
    
    var tagList = ["Cafe", "Banana", "Apple", "Melon", "papaya"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagTblView.delegate = self
        tagTblView.dataSource = self
        
        // fetch data from Restaurant db
        self.items = try! context.fetch(Restaurant.fetchRequest())
        
        // populate info
        self.txtName.text = "indexRetrieved"
        self.txtStreet.text = editIndex
    }
    
    /*   FUNCTIONS  */
    @IBAction func starBtnTapped(_ sender: Any) {
        for star in starRating {
            if star.tag <= (sender as AnyObject).tag {
                star.setBackgroundImage(UIImage.init(named: "star"), for: .normal)
            } else {
                star.setBackgroundImage(UIImage.init(named: "nostar"), for: .normal)
            }
            resto_rating = String((sender as AnyObject).tag)
        }
    }

    // TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tagBtnDropped.setTitle("Selected: \(tagList[indexPath.row])", for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tags = tableView.dequeueReusableCell(withIdentifier: "restoTags", for: indexPath)
        tags.textLabel?.text = tagList[indexPath.row]
        resto_tag = tagList[indexPath.row]
        return tags
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        let newResto = Restaurant(context: self.context)
        newResto.name = txtName.text
        newResto.street = txtStreet.text
        newResto.city = txtCity.text
        newResto.country = txtCountry.text
        newResto.postal_code = txtPostal.text
        newResto.phone = txtPhone.text
        newResto.desc = txtDescription.text
        newResto.rating = resto_rating
        newResto.tag = resto_tag
        newResto.id = UUID().uuidString // this will remain later
        
        // Save data
        do {
            try self.context.save()
            let alert = UIAlertController(title: "Success", message: "Restaurant data is updated!", preferredStyle: .alert)
            
            let alertOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(alertOk)
            present(alert, animated: true, completion: nil)
        }
        catch {
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
