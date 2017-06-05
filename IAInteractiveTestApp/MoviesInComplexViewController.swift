//
//  MoviesInComplexViewController.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 04/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit
import SQLite
import MapKit

class MoviesInComplexViewController: UITableViewController, UISearchResultsUpdating {
    
    private var searchController: UISearchController!
    private var arrayOfElements: Array<Movie>! = Array<Movie>()
    private var filteredElements: Array<Movie>! = Array<Movie>()
    private var isSecondOrMoreTimesAppearing: Bool = false
    var urlOfDataBase: URL? = nil
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(style: UITableViewStyle, newArrayOfElements: Array<Movie>) {
        
        super.init(style: style)
        
        arrayOfElements = newArrayOfElements
        filteredElements = newArrayOfElements
        
        self.initInterface()
        
    }
    
    private func initInterface() {
        
        self.initSearchController()
        self.initCellTableView()
       
        
    }
    
    private func initSearchController() {
        
        searchController = UISearchController.init(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        searchController.searchBar.barTintColor = UtilityManager.sharedInstance.backgroundColorForSearchBar
        self.tableView.tableHeaderView = searchController.searchBar
        
    }
    
    private func initCellTableView() {
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return filteredElements.count
            
        }
        
        return arrayOfElements.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45.0 * UtilityManager.sharedInstance.conversionHeight
        
    }
    
    private func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredElements = arrayOfElements.filter { element in
            
            let originalTitle = element.originalTitle != nil ? element.originalTitle! : ""
            let genre = element.genre != nil ? element.genre! : ""
            let actors = element.actors != nil ? element.actors! : ""

            return element.title.lowercased().contains(searchText.lowercased()) || originalTitle.lowercased().contains(searchText.lowercased()) || genre.lowercased().contains(searchText.lowercased()) || actors.lowercased().contains(searchText.lowercased())
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        self.filterContentForSearchText(searchText: searchController.searchBar.text!)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            cell!.textLabel?.text = filteredElements[indexPath.row].title
            cell!.detailTextLabel?.text = filteredElements[indexPath.row].originalTitle
            
        } else {
            
            cell!.textLabel?.text = arrayOfElements[indexPath.row].title
            cell!.detailTextLabel?.text = arrayOfElements[indexPath.row].originalTitle
            
        }
        
        cell?.textLabel?.textColor = UtilityManager.sharedInstance.labelsAndLinesColor
        cell?.detailTextLabel?.textColor = UtilityManager.sharedInstance.labelsAndLinesColor
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedComplex: Movie
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            selectedComplex = filteredElements[indexPath.row]
            
        } else {
            
            selectedComplex = arrayOfElements[indexPath.row]
            
        }

        let detailMovieVC = MovieDetailTabViewCotroller.init(newMovieData: selectedComplex)
        self.navigationController?.pushViewController(detailMovieVC, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //        var selectedComplex: ComplexCity
        //
        //        if self.searchController.isActive && self.searchController.searchBar.text != "" {
        //
        //            selectedComplex = self.filteredElements[indexPath.row]
        //
        //        } else {
        //
        //            selectedComplex = self.arrayOfElements[indexPath.row]
        //
        //        }
        
        let deleteClient = UITableViewRowAction.init(style: .normal,
                                                     title: "Haz algo") { (tableView, indexPath) in }
        
        deleteClient.backgroundColor = UIColor.cyan
        
        return [deleteClient]
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {}
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if isSecondOrMoreTimesAppearing == false {
            
            isSecondOrMoreTimesAppearing = true
            
        } else {
            
            
            
        }
        
    }
    
}
