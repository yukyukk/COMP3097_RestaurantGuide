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
    @IBOutlet weak var starRating: UIButton!
    
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
        lblDescription.text = restoRetrieved[9]
        
        // tag and rating
        
        /*
        for star in starRating {
            if star.tag <= (sender as AnyObject).tag {
                star.setBackgroundImage(UIImage.init(named: "star"), for: .normal)
            } else {
                star.setBackgroundImage(UIImage.init(named: "nostar"), for: .normal)
            }
            resto_rating = String((sender as AnyObject).tag)
        }
 */
        
    }
    
    
    @IBAction func editBtnClicked(_ sender: Any) {
        self.editIndex = indexRetrieved
        performSegue(withIdentifier: "editResto", sender: self)
    }
    
    // pass info segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! editRestoController
        vc.editIndex = self.indexRetrieved
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
                }
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          //stay on page
          }))
        present(alert, animated: true, completion: nil)
    }
        
}
