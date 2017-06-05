//
//  UtilityManager.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 03/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit
import Foundation

class UtilityManager: NSObject {
    
    static let sharedInstance = UtilityManager()
    
    //Conversion Screen
    static let baseScreen = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ? CGSize.init(width: 768.0, height: 1024.0) : CGSize.init(width: 375.0, height: 667.0))  //CGSize.init(width: 375.0, height: 562.5)
    static let screenSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    static let frameOfConversion = CGSize.init(width: screenSize.width/baseScreen.width, height: screenSize.height/baseScreen.height)
    
    let conversionWidth = frameOfConversion.width
    let conversionHeight = frameOfConversion.height
    
    //Interface
    let backgroundColorForSearchBar = UIColor.init(red: 51.0/255.0, green: 78.0/255.0, blue: 105.0/255.0, alpha: 1.0)
    let backgroundColorForTabBar = UIColor.init(red: 58.0/255.0, green: 78.0/255.0, blue: 111.0/255.0, alpha: 1.0)
    let backGroundColorApp = UIColor.init(red: 23.0/255.0, green: 52.0/255.0, blue: 87.0/255.0, alpha: 1.0)
    let labelsAndLinesColor = UIColor.init(red: 18.0/255.0, green: 38.0/255.0, blue: 71.0/255.0, alpha: 1.0)
    
    //UserData
    let kComplexCities = "kComplexCities"
    
    //Cache
    let kCache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) [0]
    
    //Loader
    var viewOfLoader: UIView! = nil
    var loader: UIActivityIndicatorView! = nil
    
    func currentViewController () -> UIViewController {
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let currentViewController: UIViewController = appDelegate.window!.rootViewController!
        return currentViewController
        
    }
    
    func showLoader() {
        
        if viewOfLoader == nil {
            
            viewOfLoader = UIView.init(frame: UIScreen.main.bounds)
            viewOfLoader.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
            
        }
        
        if loader == nil {
            
            let frameOfLoader = CGRect.init(x: 0.0,
                                            y: 0.0,
                                            width: 150.0 * conversionWidth,
                                            height: 150.0 * conversionHeight)
            
            loader = UIActivityIndicatorView.init(frame: frameOfLoader)
            loader.center = viewOfLoader.center
            viewOfLoader.addSubview(loader)
            
        }
        
        let currentViewController = self.currentViewController()
        loader.startAnimating()
        currentViewController.view.addSubview(viewOfLoader)
        
    }
    
    func hideLoader() {
        
        viewOfLoader.removeFromSuperview()
        loader.stopAnimating()
        
    }
    
    func conversionPositionInXFromIPhoneToIPad(positionToConvert: CGFloat) -> CGFloat {
        
        var conversorWidth: CGFloat = 1.0
        
        if isIpad() == true {
            
            conversorWidth = (UIScreen.main.bounds.width / 375.0)
            
        }
        
        return positionToConvert * conversorWidth
        
    }
    
    func conversionPositionInYFromIPhoneToIPad(positionToConvert: CGFloat) -> CGFloat {
        
        var conversorHeight: CGFloat = 1.0
        
        if isIpad() == true {
            
            conversorHeight = (UIScreen.main.bounds.height / 667.0)
            
        }
        
        return positionToConvert * conversorHeight
        
    }
    
    func isIpad() -> Bool {
        
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
    }
    
    //return true when there are not blanks
    func isValidText(testString: String) -> Bool {
        
        let whiteSpace = NSCharacterSet.whitespacesAndNewlines
        let trimmed = testString.trimmingCharacters(in: whiteSpace)
        
        if trimmed.characters.count != 0 {
            
            return true
            
        }else{
            
            return false
            
        }
        
    }
    
}

private let minimumHitArea = CGSize.init(width: 44.0, height: 44.0)

extension UIButton {
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        // if the button is hidden/disabled/transparent it can't be hit
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        
        // increase the hit frame to be at least as big as `minimumHitArea`
        let buttonSize = self.bounds.size
        let widthToAdd = max(minimumHitArea.width - buttonSize.width, 0)
        let heightToAdd = max(minimumHitArea.height - buttonSize.height, 0)
        let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        
        // perform hit test on larger frame
        return (largerFrame.contains(point)) ? self : nil
        
    }
    
}

