//
//  showRestoController.swift
//  Restaurant_Guide
//
//  Created by Lei Jing, Jes Muli, Daniel Lee on 2021-04-10.
//

import Foundation
import UIKit
import CoreData

class showRestoController: UIViewController {
    
    // Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[Restaurant]?
    
    var indexRetrieved = ""
    var restoRetrieved: [String] = []
    var restoIndex = ""
    var editIndex = ""
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStreet: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblPostal: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch data from Restaurand db
        self.items = try! context.fetch(Restaurant.fetchRequest())
        
        // populate info
        lblName.text = restoRetrieved[1]
        lblStreet.text = restoRetrieved[2]
        lblCity.text = restoRetrieved[3]
        lblCountry.text = restoRetrieved[4]
        lblPostal.text = restoRetrieved[5]
        lblPhone.text = restoRetrieved[6]
        lblTag.text = restoRetrieved[7]
        lblDescription.text = restoRetrieved[9]
        
        var stars = Int(restoRetrieved[8]) ?? 0
        let starRating = [star1, star2, star3, star4, star5]
        for star in 0..<stars {
            starRating[star]!.image = UIImage(named:"star")
        }
    }
    
    // pass info segue to editRestoController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editResto" {
            var vc = segue.destination as! editRestoController
            vc.editIndex = self.indexRetrieved
            vc.editResto = self.restoRetrieved
        }
    }
    
    @IBAction func editBtnClicked(_ sender: Any) {
        self.editIndex = indexRetrieved
        performSegue(withIdentifier: "editResto", sender: self)
    }
    
    @IBAction func btnDeleteClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this restaurant?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
          
            if let dataAppDelegatde = UIApplication.shared.delegate as? AppDelegate {
                let mngdCntxt = dataAppDelegatde.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")

                let predicate = NSPredicate(format: "id == %@", String(self.indexRetrieved))

                fetchRequest.predicate = predicate
                do{
                    let result = try mngdCntxt.fetch(fetchRequest)
                    if result.count > 0{
                        for object in result {
                            print(object)
                            mngdCntxt.delete(object as! NSManagedObject)
                            try self.context.save()
                        }
                    }
                    
                    // back to homepage
                    self.navigationController?.popToRootViewController(animated: true)
                    
                } catch {
                    print("Deleting data error: \(error)")
                }
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel)) // stay on page 
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func shareEmailBtnClicked(_ sender: Any) {
    }
    
    
    @IBAction func shareFacebookBtnClicked(_ sender: Any) {
    }
    
    
    @IBAction func shareTwitterBtnClicked(_ sender: Any) {
    }
    
}
