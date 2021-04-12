//
//  ViewController.swift
//  Restaurant_Guide
//
//  Created by Lei Jing, Jes Muli, Daniel Lee on 2021-03-01.
//

import Foundation
import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    
    /*   SEARCH BAR FUNCTIONS   */
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterCurrentDataSource(searchTerm: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController?.isActive = false
        if let searchText = searchBar.text {
            filterCurrentDataSource(searchTerm: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController?.isActive = false
        if let searchText = searchBar.text, !searchText.isEmpty {
            restoreCurrentDataSource()
        }
    }
    
    /*   TABLE VIEW FUNCTIONS   */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // pass selected resto id info to next page
        let selectResto = self.items![indexPath.row]
        self.restoIndex = selectResto.id!
        self.restoArray = [] // re-initialize
        self.restoArray += [selectResto.id!, selectResto.name!, selectResto.street!, selectResto.city!, selectResto.country!, selectResto.postal_code!, selectResto.phone!, selectResto.tag!, selectResto.rating!, selectResto.desc!]
        performSegue(withIdentifier: "showResto", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        self.fetchRestaurants()
        cc = (items!.count-1)
        if cc >= indexPath.row { // if no item is deleted
            let restaurant = self.items![indexPath.row]
            let name = String(restaurant.name!)
            let tag = String(restaurant.tag!)
            cell.textLabel?.text = "\(name) (tag: \(tag))"
        } else {
            let count = indexPath.row-1
            if count != -1 { // if not empty
                let restaurant = self.items![count]
                let name = String(restaurant.name!)
                let tag = String(restaurant.tag!)
                    cell.textLabel?.text = "\(name) (tag: \(tag))"
                }
        }
        return cell
    }
    
    // pass info segue
    override func prepare(for segue: UIStoryboardSegue!, sender: Any?) {
        if segue.identifier == "showResto" {
            var vc = segue.destination as! showRestoController
            vc.indexRetrieved = self.restoIndex
            vc.restoRetrieved = self.restoArray
        }
    }
 
    
    /*   SEARCH AND TABLE VIEW VARIABLES  */
    var searchController: UISearchController?
    var originalDataSource: [String] = [] // represents original source
    var currentDataSource: [String] = [] // represents what we're currently looking at
    var items:[Restaurant]?
    
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func clearList(_ sender: Any) {
        restoreCurrentDataSource()
    }
    
    // Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var restoIndex = String()
    var restoArray = [String]()
    var a = [String]()
    var cc = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRestaurants() // get items from core data
        
        // logo
        var logo = UIImage(named: "resto_logo_foreground.png")
        logo = logo?.withRenderingMode(.alwaysOriginal)
        // go to about page
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: logo, style:.plain, target: nil, action: nil)
        
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        //getCountFirst()
        
        // SEARCH VIEW CONTROLLER
        // override search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController!.searchResultsUpdater = self
        searchContainerView.addSubview(searchController!.searchBar)
        searchController?.searchBar.delegate = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search name or tag"
     }
 
    
    // FILTER OUT SEARCH TERM
    func filterCurrentDataSource(searchTerm: String) {
        if searchTerm.count > 0 {
            // resets source and filter out from fresh state
            currentDataSource = originalDataSource
            let filteredResults = currentDataSource.filter { $0.replacingOccurrences(of: " ", with: "").lowercased().contains(searchTerm.replacingOccurrences(of: " ", with: "").lowercased())}
        
            currentDataSource = filteredResults
            tableView.reloadData()
        }
    }
    
    func restoreCurrentDataSource() {
        currentDataSource = originalDataSource
        tableView.reloadData()
    }
    
    func fetchRestaurants() {
        // Fetch data from Core data to display in the tableview
        do {
            self.items = try context.fetch(Restaurant.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            
        }
    }
    
} // end of MainViewController: UIViewController class
