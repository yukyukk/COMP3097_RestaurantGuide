//
//  newRestoController.swift
//  Restaurant_Guide
//
//  Created by Lei Jing, Jes Muli, Daniel Lee on 2021-03-13.
//

import Foundation
import UIKit
import CoreData


class newRestoController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
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
    
    var tagList = ["Cafe", "Pizza", "Chinese", "Sushi", "Mexican Food", "Thai Food", "Seafood", "Indian Food", "Dessert", "Burgers", "Asian Food", "Italian Food", "Vegan", "Sandwiches", "Vegetarian", "Organic", "Others"]
    
    // Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagTblView.delegate = self
        tagTblView.dataSource = self
        txtDescription.text = "Type your thoughts here..."
        txtDescription.font = UIFont.systemFont(ofSize: 18)
        txtDescription.textColor = UIColor.lightGray
        txtDescription.delegate = self
    }
    
    
    /*   FUNCTIONS  */
    func textViewDidBeginEditing(_ txtDescription: UITextView) {
        if txtDescription.textColor == UIColor.lightGray {
            txtDescription.text = nil
            txtDescription.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ txtDescription: UITextView) {
        if txtDescription.text.isEmpty {
            txtDescription.text = "Type your thoughts here..."
            txtDescription.textColor = UIColor.lightGray
        }
    }
    
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
        resto_tag = tagList[indexPath.row]
        tags.textLabel?.text = resto_tag
        return tags
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        // TODO:  add validations of user inputs
        
        if txtDescription.text == "Type your thoughts here..." {
            txtDescription.text = "N/A"
        }
        
        // validations
        if ((txtName.text == nil) || (txtName.text == "") || (txtStreet.text == nil) || (txtStreet.text == "") || (txtCity.text == nil) || (txtCity.text == "") || (txtCountry.text == nil) || (txtCountry.text == "") || (txtPostal.text == nil) && (txtPostal.text == "") || (txtPhone.text == nil) || (txtPhone.text == "") || (tagBtnDropped.titleLabel!.text! == "Select Tag...")) {
            
            let alert = UIAlertController(title: "Incomplete Form", message: "Please fill-in all the details of this form.", preferredStyle: .alert)
            let alertOk = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(alertOk)
            present(alert, animated: true, completion: nil)
            
        } else {
            // Save data
            let newResto = Restaurant(context: self.context)
            newResto.name = txtName.text
            newResto.street = txtStreet.text
            newResto.city = txtCity.text
            newResto.country = txtCountry.text
            newResto.postal_code = txtPostal.text
            newResto.phone = txtPhone.text
            newResto.rating = resto_rating
            newResto.tag = tagBtnDropped.titleLabel!.text!.replacingOccurrences(of: "Selected: ", with: "")
            newResto.desc = txtDescription.text
            newResto.id = UUID().uuidString // universally unique identifier
            
            do {
                try self.context.save()
                let alert = UIAlertController(title: "Success", message: "New restaurant data is saved!", preferredStyle: .alert)
                
                let alertOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(alertOk)
                present(alert, animated: true, completion: nil)
            }
            catch {
                print("Saving new data error: \(error)")
            }
        }
    }
    
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true) // back to main page
    }

}
