//
//  showRestoController.swift
//  Restaurant_Guide
//
//  Created by Lei Jing, Jes Muli, Daniel Lee on 2021-04-10.
//

import Foundation
import UIKit
import CoreData
import MessageUI

class showRestoController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
  
    // Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[Restaurant]?
    
    var indexRetrieved = ""
    var restoRetrieved: [String] = []
    var restoIndex = ""
    var editIndex = ""
    var email = ""
    var address = ""
    var lat = 0.0
    var long = 0.0
    
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
        
        // fetch data from Restaurant db
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
        
        let stars = Int(restoRetrieved[8]) ?? 0
        let starRating = [star1, star2, star3, star4, star5]
        for star in 0..<stars {
            starRating[star]!.image = UIImage(named:"star")
        }
        
        self.address = restoRetrieved[2] + ", " + restoRetrieved[3] + ", " + restoRetrieved[4] + ", " + restoRetrieved[5]
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.address) {
            placemarks, error in
            let placemark = placemarks?.first
            self.lat = (placemark?.location?.coordinate.latitude)!
            self.long = (placemark?.location?.coordinate.longitude)!
        }
        
    }
    
    // pass info segue to editRestoController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editResto" {
            let vc = segue.destination as! editRestoController
            vc.editIndex = self.indexRetrieved
            vc.editResto = self.restoRetrieved
        } else if segue.identifier == "showMap" {
            let sm = segue.destination as! showMapsController
            sm.getAddress = self.address
        } else if segue.identifier == "showDirection" {
            let sd = segue.destination as! showDirectionController
            sd.getLat = self.lat
            sd.getLong = self.long
        }
    }
    
    @IBAction func editBtnClicked(_ sender: Any) {
        self.editIndex = indexRetrieved
        performSegue(withIdentifier: "editResto", sender: self)
    }
    
    @IBAction func mapBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    
    @IBAction func directionBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "showDirection", sender: self)
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
        let alert = UIAlertController(title: "Send to your email", message: "What is your email account?", preferredStyle: .alert)
        alert.addTextField()
        
        
        let submit = UIAlertAction(title: "Add", style: .default) { [self](action) in
            self.email = (alert.textFields![0] as UITextField).text! as String
            let mailComposeViewController = MFMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                mailComposeViewController.delegate = self
                mailComposeViewController.mailComposeDelegate = self
                mailComposeViewController.setSubject("Restaurant Guide")
                mailComposeViewController.setToRecipients([self.email])
                mailComposeViewController.setMessageBody(
                    "My favorite Restaurant: \n*Name: " + restoRetrieved[1] +
                        "\n*Address: " + restoRetrieved[2] + ", " + restoRetrieved[3] + ", " + restoRetrieved[4] + ", " + restoRetrieved[5] +
                        "\n*Phone Number: " + restoRetrieved[6] +
                        "\n*Tag: " + restoRetrieved[7] +
                        "\n*Ratings: " + restoRetrieved[8] + "/5" +
                        "\n*Description: " + restoRetrieved[9] + ""
                    , isHTML: false)
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
        }
        alert.addAction(submit)
        present(alert, animated: true, completion: nil)
        
        let alert2 = UIAlertController(title: "Success", message: "Your email is sent!", preferredStyle: .alert)
        
        alert2.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert2, animated: true, completion: nil)
    }
            
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        switch (result) {
            case .saved:
                print("Message saved")
            case .cancelled:
                print("Message cancelled")
            case .failed:
                print("Message failed")
            case .sent:
                print("Message sent")
        }
            self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareFacebookBtnClicked(_ sender: Any) {
        
        let fbText = "Restaurant Guide: \n*Name: " + restoRetrieved[1] +
            "\n*Address: " + restoRetrieved[2] + ", " + restoRetrieved[3] + ", " + restoRetrieved[4] + ", " + restoRetrieved[5] +
            "\n*Phone Number: " + restoRetrieved[6] +
            "\n*Tag: " + restoRetrieved[7] +
            "\n*Ratings: " + restoRetrieved[8] + "/5" +
            "\n*Description: " + restoRetrieved[9] + ""

        let shareString = "https://facebook.com"

        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        let url = URL(string: escapedShareString)
        UIApplication.shared.openURL(url!)
        
        let alert = UIAlertController(title: "Success", message: "Your post is sent!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func shareTwitterBtnClicked(_ sender: Any) {
        let tweetText = "Restaurant Guide: \n*Name: " + restoRetrieved[1] +
            "\n*Address: " + restoRetrieved[2] + ", " + restoRetrieved[3] + ", " + restoRetrieved[4] + ", " + restoRetrieved[5] +
            "\n*Phone Number: " + restoRetrieved[6] +
            "\n*Tag: " + restoRetrieved[7] +
            "\n*Ratings: " + restoRetrieved[8] + "/5" +
            "\n*Description: " + restoRetrieved[9] + ""

        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)"

        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        let url = URL(string: escapedShareString)
        UIApplication.shared.openURL(url!)
        
        let alert = UIAlertController(title: "Success", message: "Your tweet is sent!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
}
