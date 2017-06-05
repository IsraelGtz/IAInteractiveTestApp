//
//  MovieImageCell.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 04/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit

class MovieImageCell: UICollectionViewCell, UIScrollViewDelegate {
    
    private var scrollView: UIScrollView! = nil
    var imageView: UIImageView! = nil
    
    func adaptMySelf() {
        
        let frame = CGRect.init(x: 0.0,
                                y: 0.0,
                                width: self.frame.size.width,
                                height: self.frame.size.height)
        
        scrollView = UIScrollView.init(frame: frame)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.green
        scrollView.isUserInteractionEnabled = true
        self.addSubview(scrollView)
  
        imageView = UIImageView.init(frame: frame)
        imageView.backgroundColor = UIColor.lightGray
        
        
        let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(viewForZooming))
        imageView.addGestureRecognizer(pinchGesture)
        imageView.isUserInteractionEnabled = true
        
        self.scrollView.addSubview(imageView)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        if imageView.image != nil {
            
            return imageView
            
        }
        
        return nil
        
    }
    
    @objc private func zoomIn(sender: Any) {
        
        let rect = CGRect.init(x: self.center.x,
                               y: self.center.y,
                           width: 30.0 * UtilityManager.sharedInstance.conversionWidth,
                          height: 30.0 * UtilityManager.sharedInstance.conversionHeight)
    
        scrollView.zoom(to: rect, animated: true)
    
    }
    
    
}
