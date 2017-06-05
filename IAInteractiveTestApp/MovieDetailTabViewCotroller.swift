//
//  MovieDetailTabViewCotroller.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 04/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit

class MovieDetailTabViewCotroller: UITabBarController, UITabBarControllerDelegate {
    
    private var movieData: Movie! = nil
    
    init(newMovieData: Movie) {
        
        movieData = newMovieData
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.tabBar.isTranslucent = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let tabOne = MovieDetailViewController.init(newMovieData: movieData)
        let tabOneBarItem = UITabBarItem(title: "Info", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let tabTwo = GalleryViewController.init(newMovieData: movieData)
        let tabTwoBarItem2 = UITabBarItem(title: "Galería", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        // Create Tab one
        let tabthree = VideoPlayerViewController.init(newMovieData: movieData)   //TrailerViewController.init(newMovieData: movieData)
        let tabThreeBarItem = UITabBarItem(title: "Trailer", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        tabthree.tabBarItem = tabThreeBarItem
        
        
        // Create Tab two
        let tabFour = ScheduleViewController.init(newMovieData: movieData)
        let tabFourBarItem2 = UITabBarItem(title: "Horarios", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))
        
        tabFour.tabBarItem = tabFourBarItem2
        
        
        self.viewControllers = [tabOne, tabTwo, tabthree, tabFour]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title)")
    }
}
