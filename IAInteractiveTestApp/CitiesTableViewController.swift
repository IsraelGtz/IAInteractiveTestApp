//
//  CitiesTableViewController.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 03/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit
import SQLite

class CitiesTableViewController: UITableViewController, UISearchResultsUpdating {
    
    private var searchController: UISearchController!
    private var arrayOfElements: Array<ComplexCity>! = Array<ComplexCity>()
    private var filteredElements: Array<ComplexCity>! = Array<ComplexCity>()
    private var isSecondOrMoreTimesAppearing: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(style: UITableViewStyle, newArrayOfElements: Array<ComplexCity>) {
        
        super.init(style: style)
        
        arrayOfElements = newArrayOfElements
        filteredElements = newArrayOfElements
        
        self.initInterface()
        
    }
    
    private func initInterface() {
        
        self.initSearchController()
        self.initTableView()
        
    }
    
    private func initSearchController() {
        
        searchController = UISearchController.init(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        searchController.searchBar.barTintColor = UtilityManager.sharedInstance.backgroundColorForSearchBar
        self.tableView.tableHeaderView = searchController.searchBar
        
    }
    
    private func initTableView() {
        
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
            
            return element.name.lowercased().contains(searchText.lowercased()) || element.state.lowercased().contains(searchText.lowercased()) || element.countryName.lowercased().contains(searchText.lowercased())
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
            
            cell!.textLabel?.text = filteredElements[indexPath.row].name
            cell!.detailTextLabel?.text = filteredElements[indexPath.row].state
            
        } else {
            
            cell!.textLabel?.text = arrayOfElements[indexPath.row].name
            cell!.detailTextLabel?.text = arrayOfElements[indexPath.row].state
            
        }
        
        cell?.textLabel?.textColor = UtilityManager.sharedInstance.labelsAndLinesColor
        cell?.detailTextLabel?.textColor = UtilityManager.sharedInstance.labelsAndLinesColor
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedComplex: ComplexCity
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            selectedComplex = filteredElements[indexPath.row]
            
        } else {
            
            selectedComplex = arrayOfElements[indexPath.row]
            
        }
        
        UtilityManager.sharedInstance.showLoader()
        
        ServerManager.sharedInstance.requestToGetSqliteOfComplex(complexId: selectedComplex.id, actionsToDoWhenSucceded: { (urlOfFile) in
            
            print(urlOfFile as Any)
            
            do {
            
                let db = try Connection.init((urlOfFile?.absoluteString)!)
                
                let complexTable = Table("Complejo")
                let idComplex = Expression<Int64>("Id")
                let nameComplex = Expression<String>("Nombre")
                let latitudeComplex = Expression<String>("Latitud")
                let longitudeComplex = Expression<String>("Longitud")
                let phoneComplex = Expression<String>("Telefono")
                let idCityOfComplex = Expression<Int64>("IdCiudad")
                let addressComplex = Expression<String>("Direccion")
                let urlComplex = Expression<String>("UrlSitio")

                var arrayOfComplex: Array<Complex> = Array<Complex>()
                
                for complex in try db.prepare(complexTable) {
                    
                    let newComplex = Complex.init(newId: String(describing: complex[idComplex]),
                                              newIdCity: String(describing: complex[idCityOfComplex]),
                                             newAddress: String(describing: complex[addressComplex]),
                                               newPhone: String(describing: complex[phoneComplex]),
                                            newLatitude: String(describing: complex[latitudeComplex]),
                                           newLongitude: String(describing: complex[longitudeComplex]),
                                                newName: String(describing: complex[nameComplex]),
                                                 newUrl: String(describing: complex[urlComplex]))
                    
                    arrayOfComplex.append(newComplex)
                    
                }
                
                UtilityManager.sharedInstance.hideLoader()
                
                let complexInCityCV = ComplexInCityViewController.init(style: .plain, newArrayOfElements: arrayOfComplex)
                complexInCityCV.urlOfDataBase = urlOfFile
                self.navigationController?.pushViewController(complexInCityCV, animated: true)
            
            } catch (_) {
                
                UtilityManager.sharedInstance.hideLoader()
                
            }
            
            
        }, actionsToDoWhenFailed: {
            
            let alertController = UIAlertController(title: "ERROR",
                                                    message: "Error de conexión con la base de datos",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
                UtilityManager.sharedInstance.hideLoader()
                
            }
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        })
        
        
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

