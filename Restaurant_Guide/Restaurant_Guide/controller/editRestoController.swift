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
    var editResto: [String] = []
    var tag = ""
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPostal: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var tagBtnDropped: UIButton!
    @IBOutlet weak var tagTblView: UITableView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblLastTag: UILabel!
    
    @IBOutlet var starRating: [UIButton]!
    
    var tagList = ["Cafe", "Pizza", "Chinese", "Sushi", "Mexican Food", "Thai Food", "Seafood", "Indian Food", "Dessert", "Burgers", "Asian Food", "Italian Food", "Vegan", "Sandwiches", "Vegetarian", "Organic", "Others"]
    var resto_rating: String = "0"
    var resto_tag: String = "Others"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagTblView.delegate = self
        tagTblView.dataSource = self
        
        // fetch data from Restaurant db
        self.items = try! context.fetch(Restaurant.fetchRequest())
        
        // populate info
        self.txtName.text = editResto[1]
        self.txtStreet.text = editResto[2]
        self.txtCity.text = editResto[3]
        self.txtCountry.text = editResto[4]
        self.txtPostal.text = editResto[5]
        self.txtPhone.text = editResto[6]
        self.lblLastTag.text = "You previously selected: " + editResto[7]
        self.txtDescription.text = editResto[9]
        let stars = Int(editResto[8]) ?? 0
        for star in 0..<stars {
            starRating[star].setBackgroundImage(UIImage.init(named: "star"), for: .normal)
            resto_rating = editResto[8]
        }
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
        
        // UNCHANGED INFO
        if txtDescription.text == "Type your thoughts here..." {
            txtDescription.text = "N/A"
        }
        if tagBtnDropped.titleLabel!.text! == "Select Tag..." { // if tag is not changed
            self.tag = editResto[7]
        } else {
            self.tag = tagBtnDropped.titleLabel!.text!.replacingOccurrences(of: "Selected: ", with: "")
        }
        
        
        // validations
        if ((txtName.text == nil) || (txtName.text == "") || (txtStreet.text == nil) || (txtStreet.text == "") || (txtCity.text == nil) || (txtCity.text == "") || (txtCountry.text == nil) || (txtCountry.text == "") || (txtPostal.text == nil) && (txtPostal.text == "") || (txtPhone.text == nil) || (txtPhone.text == "")) {
            
            let alert = UIAlertController(title: "Incomplete Form", message: "Please fill-in all the details of this form.", preferredStyle: .alert)
            let alertOk = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(alertOk)
            present(alert, animated: true, completion: nil)
            
        } else {
            
            let request : NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", String(self.editIndex))

            context.performAndWait {
                do {
                    let result = try context.fetch(request)
                    //Update
                    for editResto in result { // assuming they're changed
                        editResto.name = txtName.text
                        editResto.name = txtName.text
                        editResto.street = txtStreet.text
                        editResto.city = txtCity.text
                        editResto.country = txtCountry.text
                        editResto.postal_code = txtPostal.text
                        editResto.phone = txtPhone.text
                        editResto.desc = txtDescription.text
                        editResto.rating = resto_rating
                        editResto.tag = self.tag
                    }
                }
                catch {
                    print("Fetching data error: \(error)")
                }
            }
        }
        
        // save data
        if context.hasChanges {
            context.performAndWait {
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
                    print("Saving edited data error: \(error)")
                }
            }
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
