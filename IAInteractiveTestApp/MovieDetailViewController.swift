//
//  MovieDetailViewController.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 04/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    private var movieData: Movie! = nil
    private var mainScrollView: UIScrollView! = nil
    private var titleLabel: UILabel! = nil
    private var originalTitleLabel: UILabel! = nil
    private var moviewImageView: UIImageView! = nil
    private var synopsisLabel: UILabel! = nil
    private var actorsLabel: UILabel! = nil
    
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
        self.view.backgroundColor = UIColor.black
        self.title = "Info"
        
        let dragGesture = UIPanGestureRecognizer.init(target: self, action: #selector(dragGestureActivated(gestureRecognized:)))
        dragGesture.maximumNumberOfTouches = 1
        self.view.addGestureRecognizer(dragGesture)
        
        self.initInterface()
        
    }
    
    private func initInterface() {
        
        self.initMainScrollView()
        self.initTitleLabel()
        self.initOriginalTitleLabel()
        self.initMoviewImageView()
        self.initSynopsisLabel()
        self.initActorsLabel()
    
    }
    
    private func initMainScrollView() {
        
        let frameForView = CGRect.init(x: 0.0,
                                       y: 0.0,
                                       width: self.view.frame.size.width,
                                       height: self.view.frame.size.height - (self.tabBarController != nil ? self.tabBarController!.tabBar.frame.size.height : 0.0))
        
        mainScrollView = UIScrollView.init(frame: frameForView)
        mainScrollView.contentSize = CGSize.init(width: mainScrollView.frame.size.width,
                                                 height: mainScrollView.frame.size.height + (60.0 * UtilityManager.sharedInstance.conversionHeight))
        mainScrollView.backgroundColor = UIColor.clear
        
        self.view.addSubview(mainScrollView)
        
    }
    
    private func initTitleLabel() {
        
        let frameForLabel = CGRect.init(x: 0.0,
                                        y: 0.0,
                                        width: self.mainScrollView.frame.size.width,
                                        height: CGFloat.greatestFiniteMagnitude)
        
        titleLabel = UILabel.init(frame: frameForLabel)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        let font = UIFont.init(name: "AppleSDGothicNeo-Light",
                               size: 28.0 * UtilityManager.sharedInstance.conversionWidth)
        let color = UIColor.white
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        
        let stringWithFormat = NSMutableAttributedString(
            string: movieData.title,
            attributes:[NSFontAttributeName: font!,
                        NSParagraphStyleAttributeName: style,
                        NSForegroundColorAttributeName: color
            ]
        )
        
        titleLabel.attributedText = stringWithFormat
        titleLabel.sizeToFit()
        let newFrame = CGRect.init(x: (self.view.frame.size.width / 2.0) - (titleLabel.frame.size.width / 2.0),
                                   y: 50.0 * UtilityManager.sharedInstance.conversionHeight,
                                   width: titleLabel.frame.size.width,
                                   height: titleLabel.frame.size.height)
        titleLabel.frame = newFrame
        
        mainScrollView.addSubview(titleLabel)
        
    }
    
    private func initOriginalTitleLabel() {
        
        let frameForLabel = CGRect.init(x: 0.0,
                                        y: 0.0,
                                        width: self.mainScrollView.frame.size.width,
                                        height: CGFloat.greatestFiniteMagnitude)
        
        originalTitleLabel = UILabel.init(frame: frameForLabel)
        originalTitleLabel.numberOfLines = 0
        originalTitleLabel.lineBreakMode = .byWordWrapping
        
        let font = UIFont.init(name: "AppleSDGothicNeo-Light",
                               size: 14.0 * UtilityManager.sharedInstance.conversionWidth)
        let color = UIColor.white
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        
        let stringWithFormat = NSMutableAttributedString(
            string: movieData.originalTitle,
            attributes:[NSFontAttributeName: font!,
                        NSParagraphStyleAttributeName: style,
                        NSForegroundColorAttributeName: color
            ]
        )
        
        originalTitleLabel.attributedText = stringWithFormat
        originalTitleLabel.sizeToFit()
        let newFrame = CGRect.init(x: (self.view.frame.size.width / 2.0) - (originalTitleLabel.frame.size.width / 2.0),
                                   y: titleLabel.frame.origin.y + titleLabel.frame.size.height + (20.0 * UtilityManager.sharedInstance.conversionHeight),
                                   width: originalTitleLabel.frame.size.width,
                                   height: originalTitleLabel.frame.size.height)
        originalTitleLabel.frame = newFrame
        
        mainScrollView.addSubview(originalTitleLabel)
        
    }
    
    private func initMoviewImageView() {
        
        let newFrame = CGRect.init(x: (self.mainScrollView.frame.size.width / 2.0) - (144.0 * UtilityManager.sharedInstance.conversionWidth),
                                   y: originalTitleLabel.frame.origin.y + originalTitleLabel.frame.size.height + (20.0 * UtilityManager.sharedInstance.conversionHeight),
                                   width: 288.0 * UtilityManager.sharedInstance.conversionWidth,
                                   height: 155.0 * UtilityManager.sharedInstance.conversionHeight)
        
        moviewImageView = UIImageView.init(frame: newFrame)
        
        if movieData.imagesNameForMultimedia.count > 0 {
            
            moviewImageView.imageFromUrl(urlString: kURLForImages + movieData.imagesNameForMultimedia[0])
            
        }
        
        moviewImageView.backgroundColor = UIColor.lightGray
        mainScrollView.addSubview(moviewImageView)
        
    }
    
    private func initSynopsisLabel() {
        
        let frameForLabel = CGRect.init(x: 0.0,
                                        y: 0.0,
                                        width: self.mainScrollView.frame.size.width - (20.0 * UtilityManager.sharedInstance.conversionWidth),
                                        height: CGFloat.greatestFiniteMagnitude)
        
        synopsisLabel = UILabel.init(frame: frameForLabel)
        synopsisLabel.numberOfLines = 0
        synopsisLabel.lineBreakMode = .byWordWrapping
        
        let font = UIFont.init(name: "AppleSDGothicNeo-Light",
                               size: 14.0 * UtilityManager.sharedInstance.conversionWidth)
        let color = UIColor.white
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.justified
        
        let stringWithFormat = NSMutableAttributedString(
            string: ("Sinopsis:\n    \(movieData.synopsis!)"),
            attributes:[NSFontAttributeName: font!,
                        NSParagraphStyleAttributeName: style,
                        NSForegroundColorAttributeName: color
            ]
        )
        
        synopsisLabel.attributedText = stringWithFormat
        synopsisLabel.sizeToFit()
        let newFrame = CGRect.init(x: 10.0 * UtilityManager.sharedInstance.conversionWidth,
                                   y: moviewImageView.frame.origin.y + moviewImageView.frame.size.height + (30.0 * UtilityManager.sharedInstance.conversionHeight),
                                   width: synopsisLabel.frame.size.width,
                                   height: synopsisLabel.frame.size.height)
        synopsisLabel.frame = newFrame
        
        mainScrollView.addSubview(synopsisLabel)
        
    }
    
    private func initActorsLabel() {
        
        let frameForLabel = CGRect.init(x: 0.0,
                                        y:  self.mainScrollView.frame.size.width - (20.0 * UtilityManager.sharedInstance.conversionWidth),
                                        width: self.mainScrollView.frame.size.width,
                                        height: CGFloat.greatestFiniteMagnitude)
        
        actorsLabel = UILabel.init(frame: frameForLabel)
        actorsLabel.numberOfLines = 0
        actorsLabel.lineBreakMode = .byWordWrapping
        
        let font = UIFont.init(name: "AppleSDGothicNeo-Light",
                               size: 14.0 * UtilityManager.sharedInstance.conversionWidth)
        let color = UIColor.white
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.justified
        
        let stringWithFormat = NSMutableAttributedString(
            string: ("Reparto: \n\(movieData.actors!)"),
            attributes:[NSFontAttributeName: font!,
                        NSParagraphStyleAttributeName: style,
                        NSForegroundColorAttributeName: color
            ]
        )
        
        actorsLabel.attributedText = stringWithFormat
        actorsLabel.sizeToFit()
        let newFrame = CGRect.init(x: 10.0 * UtilityManager.sharedInstance.conversionWidth,
                                   y: synopsisLabel.frame.origin.y + synopsisLabel.frame.size.height + (20.0 * UtilityManager.sharedInstance.conversionHeight),
                                   width: actorsLabel.frame.size.width,
                                   height: actorsLabel.frame.size.height)
        actorsLabel.frame = newFrame
        
        mainScrollView.addSubview(actorsLabel)
        
    }
    
    @objc private func dragGestureActivated(gestureRecognized: UIPanGestureRecognizer) {
        
        let vel = gestureRecognized.velocity(in: self.view)
        
        if vel.x > 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        } else { //right
            
            self.tabBarController?.selectedIndex = 1
            
        }
        
    }



}

