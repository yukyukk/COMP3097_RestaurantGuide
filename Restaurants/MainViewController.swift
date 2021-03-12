//
//  ViewController.swift
//  Restaurants
//
//  Created by Daniel Lee on 2021-03-05.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    } ()
    
    private var models = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Restaurant App"
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Restaurant", message: "Enter Details", preferredStyle: .alert)
        alert.addTextField {
            (textField) in textField.placeholder = "Enter Name"
        }
        alert.addTextField {
            (textField) in textField.placeholder = "Enter Address"
        }
        alert.addTextField {
            (textField) in textField.placeholder = "Enter City"
        }
        alert.addTextField {
            (textField) in textField.placeholder = "Enter Province"
        }
        alert.addTextField {
            (textField) in textField.placeholder = "Enter Postal Code"
        }
        alert.addTextField {
            (textField) in textField.placeholder = "Enter Rating"
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let nameField = alert.textFields?[0], let name = nameField.text, !name.isEmpty else {
                return
            }
            guard let addressField = alert.textFields?[1], let address = addressField.text, !address.isEmpty else {
                return
            }
            guard let cityField = alert.textFields?[2], let city = cityField.text, !city.isEmpty else {
                return
            }
            guard let provinceField = alert.textFields?[3], let province = provinceField.text, !province.isEmpty else {
                return
            }
            guard let postalCodeField = alert.textFields?[4], let postalCode = postalCodeField.text, !postalCode.isEmpty else {
                return
            }
            guard let ratingField = alert.textFields?[5], let rating = ratingField.text, !rating.isEmpty else {
                return
            }
//            let nameField = alert.textFields?[0]
//            let addressField = alert.textFields?[1]
//            let cityField = alert.textFields?[2]
//            let provinceField = alert.textFields?[3]
//            let postalCodeField = alert.textFields?[4]
//            let ratingField = alert.textFields?[5]
//
//            let name = nameField?.text
//            let address = addressField?.text
//            let city = cityField?.text
//            let province = provinceField?.text
//            let postalCode = postalCodeField?.text
//            let rating = ratingField?.text
            
            
     /*       guard let text = field.text, !text.isEmpty else {
                return
            }
     */
            
            self?.createItem(name: name, address: address, city: city, province: province, postal_code: postalCode, rating: Int64(rating)!)
        }))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "Edit Restaurant",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        
        sheet.addAction(UIAlertAction(title:"Edit", style: .default, handler: {_ in
                                        let alert = UIAlertController(title: "New Restaurant",
                                                                      message: "Enter Details",
                                                                      preferredStyle: .alert)
                                        alert.addTextField(configurationHandler: nil)
                                        alert.addTextField(configurationHandler: nil)
                                        alert.addTextField(configurationHandler: nil)
                                        alert.addTextField(configurationHandler: nil)
                                        alert.addTextField(configurationHandler: nil)
                                        alert.addTextField(configurationHandler: nil)
                                        alert.textFields?[0].text = item.name
                                        alert.textFields?[1].text = item.address
                                        alert.textFields?[2].text = item.city
                                        alert.textFields?[3].text = item.province
                                        alert.textFields?[4].text = item.postal_code
                                        alert.textFields?[5].text = String(item.rating)
            
                alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                    guard let nameField = alert.textFields?[0], let name = nameField.text, !name.isEmpty else {
                        return
                    }
                    guard let addressField = alert.textFields?[1], let address = addressField.text, !address.isEmpty else {
                        return
                    }
                    guard let cityField = alert.textFields?[2], let city = cityField.text, !city.isEmpty else {
                        return
                    }
                    guard let provinceField = alert.textFields?[3], let province = provinceField.text, !province.isEmpty else {
                        return
                    }
                    guard let postalCodeField = alert.textFields?[4], let postalCode = postalCodeField.text, !postalCode.isEmpty else {
                        return
                    }
                    guard let ratingField = alert.textFields?[5], let rating = ratingField.text, !rating.isEmpty else {
                        return
                    }
                    self?.updateItem(item: item, name: name, address: address, city: city, province: province, postal_code: postalCode, rating: Int64(rating)!)
                }))
                self.present(alert, animated: true)
            }))
        sheet.addAction(UIAlertAction(title:"Delete", style: .destructive, handler: { [weak self] _ in
                                    self?.deleteItem(item: item)
        }))
        present(sheet, animated:true)
        }

    // Core Data
    
    
    func getAllItems() {
        
        do {
            models = try context.fetch(Restaurant.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            // error handling
        }
    }
    
    func createItem(name: String, address: String, city: String, province: String, postal_code: String, rating: Int64) {
        let newItem = Restaurant(context: context)
        newItem.name = name
        newItem.address = address
        newItem.city = city
        newItem.province = province
        newItem.postal_code = postal_code
        newItem.rating = rating
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            // error
        }
    }
    
    func deleteItem(item: Restaurant) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            // error
        }
    }
    
    func updateItem(item: Restaurant, name: String, address: String, city: String, province: String, postal_code: String, rating: Int64) {
        item.name = name
        item.address = address
        item.city = city
        item.province = province
        item.postal_code = postal_code
        item.rating = rating
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            // error
        }
    }
}



