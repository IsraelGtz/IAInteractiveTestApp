//
//  ComplexInCityViewController.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 04/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit
import SQLite
import MapKit

class ComplexInCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    private var tableView: UITableView! = nil
    private var searchController: UISearchController!
    private var arrayOfElements: Array<Complex>! = Array<Complex>()
    private var filteredElements: Array<Complex>! = Array<Complex>()
    private var isSecondOrMoreTimesAppearing: Bool = false
    var urlOfDataBase: URL? = nil
    
    private var mapView: MKMapView! = nil
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(style: UITableViewStyle, newArrayOfElements: Array<Complex>) {
        
        super.init(nibName: nil, bundle: nil)
        
        arrayOfElements = newArrayOfElements
        filteredElements = newArrayOfElements
        
        self.initInterface(style: style)
        
    }
    
    private func initInterface(style: UITableViewStyle) {
        
        self.view = UIView.init(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.white
        
        self.initTableView(style: style)
        self.initSearchController()
        self.initCellTableView()
        
        self.initMapView()
        
    }
    
    private func initTableView(style: UITableViewStyle) {
        
        let frameForTableView = CGRect.init(x: 0.0,
                                            y: 0.0,
                                            width: UIScreen.main.bounds.width,
                                            height: UIScreen.main.bounds.height / 2.0)
        self.tableView = UITableView.init(frame: frameForTableView, style: style)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
        
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
    
    private func initMapView() {

        let frameForMap = CGRect.init(x: 0.0,
                                      y: self.tableView.frame.origin.y + self.tableView.frame.height,
                                  width: self.view.frame.size.width,
                                 height: self.view.frame.size.height - self.tableView.frame.size.height)
        
        self.mapView = MKMapView.init(frame: frameForMap)
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        for complex in arrayOfElements {

            if Double(complex.latitude) != nil && Double(complex.longitude) != nil {
            
                let annotation = MKPointAnnotation()
                
                let latitude = CLLocationDegrees.init(Double(complex.latitude)!)
                let longitude = CLLocationDegrees.init(Double(complex.longitude)!)
            
                annotation.coordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
                annotation.title = complex.name
                annotation.subtitle = "\(complex.address!) + \n\(complex.phone!)"
                mapView.addAnnotation(annotation)
                
            }
            
        }
        
        
        
        self.view.addSubview(mapView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return filteredElements.count
            
        }
        
        return arrayOfElements.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45.0 * UtilityManager.sharedInstance.conversionHeight
        
    }
    
    private func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredElements = arrayOfElements.filter { element in
            
            return element.name.lowercased().contains(searchText.lowercased()) || element.address.lowercased().contains(searchText.lowercased())
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        self.filterContentForSearchText(searchText: searchController.searchBar.text!)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            cell!.textLabel?.text = filteredElements[indexPath.row].name
            cell!.detailTextLabel?.text = filteredElements[indexPath.row].address
            
        } else {
            
            cell!.textLabel?.text = arrayOfElements[indexPath.row].name
            cell!.detailTextLabel?.text = arrayOfElements[indexPath.row].address
            
        }
        
        cell?.textLabel?.textColor = UtilityManager.sharedInstance.labelsAndLinesColor
        cell?.detailTextLabel?.textColor = UtilityManager.sharedInstance.labelsAndLinesColor
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedComplex: Complex
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            selectedComplex = filteredElements[indexPath.row]
            
        } else {
            
            selectedComplex = arrayOfElements[indexPath.row]
            
        }
        
            
        do {
                
            let db = try Connection.init((self.urlOfDataBase?.absoluteString)!)
                
            let billBoardTable = Table("Cartelera")
            let movieTable = Table("Pelicula")
            let multimediaTable = Table("Multimedia")
            
            let idPelicula = Expression<Int64>("IdPelicula")
            let idComplejo = Expression<Int64>("IdComplejo")
            
            let dateMovie = Expression<String>("Fecha")
            let timeMovie = Expression<String>("Horario")

            let idMovie = Expression<Int64>("id")
            let titleMovie = Expression<String>("Titulo")
            let originalTitleMovie = Expression<String>("TituloOriginal")
            let genreMovie = Expression<String>("Genero")
            let actorsMovie = Expression<String>("Actores")
            let clasificationMovie = Expression<String>("Clasificacion")
            let durationMovie = Expression<String>("Duracion")
            let directorMovie = Expression<String>("Director")
            let synopsisMovie = Expression<String>("Sinopsis")
            let mainImageMovie = Expression<String>("ImagenCartel")
            
            let fileTypeMultimedia = Expression<String>("Tipo")
            let fileNameMultimedia = Expression<String>("Archivo")

            UtilityManager.sharedInstance.showLoader()
            
            var arrayOfMovieId: Array<Movie> = Array<Movie>()
            
            let results = billBoardTable.select(distinct: idPelicula).where(idComplejo == Int64(selectedComplex.id)!)
            
            
            
            for show in try db.prepare(results) {
                
                let newMoview = Movie()
                var arrayOfImages = Array<String>()
                var arrayOfVideos = Array<String>()
                newMoview.id = String(show[idPelicula])
                
                let multimediaData = multimediaTable.filter(idPelicula == show[idPelicula])
                
                let schedule = billBoardTable.select([dateMovie, timeMovie]).where(idPelicula == show[idPelicula])
                
                var newArrayForSchedule = [String: Array<String>]()
                var lastDate = ""
                var arrayOfTimes = [String]()
                
                for day in try db.prepare(schedule) {
                    
                    let date = day[dateMovie]
                    let time = day[timeMovie]
                    
                    if date != lastDate {
                        
                        newArrayForSchedule[lastDate] = arrayOfTimes
                        
                        lastDate = date
                        
                        arrayOfTimes.removeAll()
                        arrayOfTimes.append(time)
                        
                    } else {
                        
                        arrayOfTimes.append(time)
                        
                    }
                    
                }
                
                newMoview.schedule = newArrayForSchedule
                
                for multimedia in try db.prepare(multimediaData) {
                    
                    if multimedia[fileTypeMultimedia] == "Imagen" {
                        
                        arrayOfImages.append(multimedia[fileNameMultimedia])
                        
                    } else
                    
                    if multimedia[fileTypeMultimedia] == "Video" {
                            
                        arrayOfVideos.append(multimedia[fileNameMultimedia])
                            
                    }
                    
                }
                
                newMoview.imagesNameForMultimedia = arrayOfImages
                newMoview.videoNameForMultimedia = arrayOfVideos
                
                let movie = movieTable.filter(idMovie == show[idPelicula])
                
                for element in try db.prepare(movie) {
                    
                    newMoview.title = String(describing: element[titleMovie])
                    newMoview.originalTitle = String(describing: element[originalTitleMovie])
                    newMoview.genre = String(describing: element[genreMovie])
                    newMoview.clasification = String(describing: element[clasificationMovie])
                    newMoview.duration = String(describing: element[durationMovie])
                    newMoview.director = String(describing: element[directorMovie])
                    newMoview.actors = String(describing: element[actorsMovie])
                    newMoview.synopsis = String(describing: element[synopsisMovie])
                    newMoview.imageName = String(describing: element[mainImageMovie])
                    
                }
                
                arrayOfMovieId.append(newMoview)
                
            }
            
            UtilityManager.sharedInstance.hideLoader()
            
            let moviesListCV = MoviesInComplexViewController.init(style: .plain, newArrayOfElements: arrayOfMovieId)
            moviesListCV.urlOfDataBase = urlOfDataBase
            self.navigationController?.pushViewController(moviesListCV, animated: true)
            
        } catch (_) {
                
            let alertController = UIAlertController(title: "ERROR",
                                                    message: "Error de conexión con la base de datos",
                                                    preferredStyle: UIAlertControllerStyle.alert)
                
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    

                    
            }
            alertController.addAction(cancelAction)
                
            self.present(alertController, animated: true, completion: nil)
                
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {}
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if isSecondOrMoreTimesAppearing == false {
            
            isSecondOrMoreTimesAppearing = true
            
        } else {
            
            
            
        }
        
    }
    
}
