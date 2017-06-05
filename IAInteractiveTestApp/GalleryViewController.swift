//
//  GalleryViewController.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 04/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    private var movieData: Movie! = nil
    
    private var collectionView: UICollectionView! = nil
    
    private var mainScrollView: UIScrollView! = nil
    private var arrayOfImagesView: Array<UIImageView>! = Array<UIImageView>()
    
    let kURLForImages = "http://www.cinepolis.com/_MOVIL/iPhone/galeria/thumb/"

    init(newMovieData: Movie) {
        
        movieData = newMovieData
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.view = UIView.init(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.red
        self.title = "Galería"
        
        let dragGesture = UIPanGestureRecognizer.init(target: self, action: #selector(dragGestureActivated(gestureRecognized:)))
        dragGesture.maximumNumberOfTouches = 1
        self.view.addGestureRecognizer(dragGesture)
        
        self.initInterface()
        
    }
    
    private func initInterface() {
    
        self.initCollectionView()
//        self.initMainScrollView()
    
    }
    
    private func initCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(MovieImageCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.black
        
        self.view.addSubview(collectionView)
        
    }
    
    private func initMainScrollView() {
        
        let newFrame = CGRect.init(x: 0.0,
                                   y: 0.0,
                              width: self.view.frame.size.width,
                              height: self.view.frame.size.height - (self.tabBarController != nil ? self.tabBarController!.tabBar.frame.size.height : 0.0))
        
        mainScrollView = UIScrollView.init(frame: newFrame)
        
        if movieData.imagesNameForMultimedia.count > 0 {
            
            let newContentSize = CGSize.init(width: self.mainScrollView.frame.size.width * CGFloat(movieData.imagesNameForMultimedia.count),
                                             height: self.mainScrollView.contentSize.height)
            
            mainScrollView.contentSize = newContentSize
            mainScrollView.delegate = self
            mainScrollView.isPagingEnabled = true
            mainScrollView.minimumZoomScale = 0.8
            mainScrollView.maximumZoomScale = 1.2
            
            for i in 0..<movieData.imagesNameForMultimedia.count {
                
                let finalXPosition = CGFloat(i) * self.mainScrollView.frame.size.width
                
                let imageFrame = CGRect.init(x: finalXPosition + ((self.mainScrollView.frame.size.width / 2.0) - (144.0 * UtilityManager.sharedInstance.conversionWidth)),
                                             y: (self.mainScrollView.frame.size.width / 2.0) - (77.5 * UtilityManager.sharedInstance.conversionWidth),
                                         width: 288.0 * UtilityManager.sharedInstance.conversionWidth,
                                         height: 155.0 * UtilityManager.sharedInstance.conversionHeight)
                
                let newImage = UIImageView.init(frame: imageFrame)
                newImage.imageFromUrl(urlString: kURLForImages + movieData.imagesNameForMultimedia[i])
                self.arrayOfImagesView.append(newImage)
                
                self.mainScrollView.addSubview(newImage)
                
            }
            
        }
        
        self.view.addSubview(mainScrollView)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        let page: Int = Int((self.mainScrollView.contentOffset.x + (0.5 * self.mainScrollView.frame.size.width)) / self.mainScrollView.frame.width) + 1
        
        return arrayOfImagesView[page - 1]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movieData.imagesNameForMultimedia.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! MovieImageCell
        
        cell.adaptMySelf()
        cell.imageView.imageFromUrl(urlString: kURLForImages + movieData.imagesNameForMultimedia[indexPath.row])
        
        cell.backgroundColor = UIColor.green
        cell.isUserInteractionEnabled = true
        
        return cell
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: 288.0 * UtilityManager.sharedInstance.conversionWidth, height: 155.0 * UtilityManager.sharedInstance.conversionHeight)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    @objc private func dragGestureActivated(gestureRecognized: UIPanGestureRecognizer) {
        
        let vel = gestureRecognized.velocity(in: self.view)
        
        if vel.x > 0 {
            
            self.tabBarController?.selectedIndex = 0
            
        } else {
            
            self.tabBarController?.selectedIndex = 2
            
        }
        
    }
    
}
