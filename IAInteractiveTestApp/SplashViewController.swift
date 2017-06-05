//
//  SplashViewController.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 03/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    private var mainTabBarController: MainTabBarController! = nil
    private var arrayOfComplexCities: Array<ComplexCity> = Array<ComplexCity>()
    
    override func loadView() {
        
        self.view = UIView.init(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.black
        
    }
    
    override func viewDidLoad() {
        
        UtilityManager.sharedInstance.showLoader()
        
        ServerManager.sharedInstance.getAllTheCitiesCinepolis(actionsToMakeWhenSucceeded: { arrayOfComplexCities in
            
            print(arrayOfComplexCities)
            
            self.arrayOfComplexCities = arrayOfComplexCities
            
            self.saveDataArrayOfComplexCities(arrayOfComplexCities: arrayOfComplexCities)
            
            UtilityManager.sharedInstance.hideLoader()
            
            self.initAndChangeRootToMainTabBarController()
            
        }, actionsToMakeWhenFailed: {
            
            UtilityManager.sharedInstance.hideLoader()
            
            let alertController = UIAlertController(title: "ERROR",
                                                    message: "Se cargarán los últimos complejos descargados",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
                self.arrayOfComplexCities = self.getDataArrayOfComplexCities()
                self.initAndChangeRootToMainTabBarController()
                
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        })
    
    }
    
    private func initAndChangeRootToMainTabBarController() {
        
        let animeListVC = CitiesTableViewController(style: .plain, newArrayOfElements: self.arrayOfComplexCities)
        let mainNavigationController = UINavigationController.init(rootViewController: animeListVC)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        UIView.transition(with: appDelegate.window!,
                          duration: 0.25,
                          options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {
                            self.view.alpha = 0.0
                            appDelegate.window?.rootViewController = mainNavigationController
                            appDelegate.window?.makeKeyAndVisible()
        }, completion: nil)
        
    }
    
    private func saveDataArrayOfComplexCities(arrayOfComplexCities: Array<ComplexCity>) {
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: arrayOfComplexCities)
        UserDefaults.standard.set(encodedData, forKey: UtilityManager.sharedInstance.kComplexCities)
        UserDefaults.standard.synchronize()
        
    }
    
    private func getDataArrayOfComplexCities() -> Array<ComplexCity> {
        
        let decoded  = UserDefaults.standard.object(forKey: UtilityManager.sharedInstance.kComplexCities) as! Data
        return NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Array<ComplexCity>
        
    }
    
}
