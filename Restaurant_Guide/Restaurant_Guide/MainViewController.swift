//
//  ViewController.swift
//  Restaurant_Guide
//
//  Created by Lei Jing, Jes Muli, Daniel Lee on 2021-03-01.
//

import Foundation
import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    // SEARCH BAR FUNCTIONS
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterCurrentDataSource(searchTerm:  searchText)
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
    
    // TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Selection", message: "Selected: \(currentDataSource[indexPath.row])", preferredStyle: .alert)
        
        searchController?.isActive = false
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = currentDataSource[indexPath.row]
        return cell
    }
    
    
    // SEARCH AND TABLE VIEW VARIABLES
    var searchController: UISearchController?
    var originalDataSource: [String] = [] // represents original source
    var currentDataSource: [String] = [] // represents what we're currently looking at
    
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func clearList(_ sender: Any) {
        restoreCurrentDataSource()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // logo
        var logo = UIImage(named: "resto_logo_foreground.png")
        logo = logo?.withRenderingMode(.alwaysOriginal)
        // go to about page
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: logo, style:.plain, target: nil, action: nil)
        
        
        
        addRestoToDataSource(restoCount: 1, resto: "McDonalds", tag: "cafe")
        addRestoToDataSource(restoCount: 2, resto: "Tim Hortons", tag: "cafe")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        currentDataSource = originalDataSource // current view is dependent to orig data source
        
       
        
        // SEARCH VIEW CONTROLLER
        // override search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController!.searchResultsUpdater = self
        searchContainerView.addSubview(searchController!.searchBar)
        searchController?.searchBar.delegate = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search name or tag"
     }
    
    
    // POPULATE LIST
    func addRestoToDataSource(restoCount: Int, resto: String, tag: String) {
        
        //for index in 0...restoCount {
            originalDataSource.append("\(resto) (\(tag))")
        //}
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
    
    

} // end of MainViewController: UIViewController class
