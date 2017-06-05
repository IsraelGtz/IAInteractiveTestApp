//
//  VideoPlayerViewController.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 04/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    
    private var movieData: Movie! = nil
    private let avPlayer = AVPlayer()
    private var avPlayerLayer: AVPlayerLayer!
    private let invisibleButton = UIButton()
    private var timeObserver: AnyObject!
    private let timeRemainingLabel = UILabel()
    private let seekSlider = UISlider()
    private var playerRateBeforeSeek: Float = 0
    private var playbackLikelyToKeepUpContext = 0
    private let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    private let kURLVideo = "http://movil.cinepolis.com/Android/trailer/"
    
    init(newMovieData: Movie) {
        
        movieData = newMovieData
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dragGesture = UIPanGestureRecognizer.init(target: self, action: #selector(dragGestureActivated(gestureRecognized:)))
        dragGesture.maximumNumberOfTouches = 1
        self.view.addGestureRecognizer(dragGesture)
        
        self.title = "Trailer"
        
        view.backgroundColor = UIColor.black
        
        // An AVPlayerLayer is a CALayer instance to which the AVPlayer can
        // direct its visual output. Without it, the user will see nothing.
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        view.addSubview(invisibleButton)
        invisibleButton.addTarget(self, action: #selector(invisibleButtonTapped),
                                  for: .touchUpInside)
        
        if movieData.videoNameForMultimedia.count > 0 {
        
            let url = NSURL(string: kURLVideo + movieData.videoNameForMultimedia[0] + ".mp4")
            let playerItem = AVPlayerItem(url: url! as URL)
            avPlayer.replaceCurrentItem(with: playerItem)
            
            let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
            timeObserver = avPlayer.addPeriodicTimeObserver(forInterval: timeInterval,
                                                            queue: DispatchQueue.main) { (elapsedTime: CMTime) -> Void in
                                                                
                                                                //                                                                    print("elapsedTime now:", CMTimeGetSeconds(elapsedTime))
                                                                // print("elapsedTime now:", CMTimeGetSeconds(elapsedTime))
                                                                self.observeTime(elapsedTime: elapsedTime)
                } as AnyObject!
            
            timeRemainingLabel.textColor = .white
            view.addSubview(timeRemainingLabel)
            
            view.addSubview(seekSlider)
            seekSlider.addTarget(self, action: #selector(sliderBeganTracking),
                                 for: .touchDown)
            seekSlider.addTarget(self, action: #selector(sliderEndedTracking),
                                 for: [.touchUpInside, .touchUpOutside])
            seekSlider.addTarget(self, action: #selector(sliderValueChanged),
                                 for: .valueChanged)
            
            loadingIndicatorView.hidesWhenStopped = true
            view.addSubview(loadingIndicatorView)
            avPlayer.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp",
                                 options: .new, context: &playbackLikelyToKeepUpContext)
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        avPlayer.pause()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingIndicatorView.startAnimating()
        avPlayer.play() // Start the playback
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Layout subviews manually
        avPlayerLayer.frame = view.bounds
        invisibleButton.frame = view.bounds
        
        let controlsHeight: CGFloat = 200 * UtilityManager.sharedInstance.conversionHeight
        let controlsY: CGFloat = view.bounds.size.height - controlsHeight
        timeRemainingLabel.frame = CGRect(x: 5  * UtilityManager.sharedInstance.conversionWidth,
                                          y: controlsY, width: 60 * UtilityManager.sharedInstance.conversionWidth, height: controlsHeight)
        
        seekSlider.frame = CGRect(x: timeRemainingLabel.frame.origin.x + timeRemainingLabel.bounds.size.width,
                                  y: controlsY,
                              width: view.frame.size.width - timeRemainingLabel.frame.size.width - (30.0 * UtilityManager.sharedInstance.conversionWidth),
                             height: controlsHeight)
        
        loadingIndicatorView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        
    }
    
    private func updateTimeLabel(elapsedTime: Float64, duration: Float64) {
        let timeRemaining: Float64 = CMTimeGetSeconds(avPlayer.currentItem!.duration) - elapsedTime
        timeRemainingLabel.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
    }
    
    func invisibleButtonTapped(sender: UIButton) {
        let playerIsPlaying = avPlayer.rate > 0
        if playerIsPlaying {
            avPlayer.pause()
        } else {
            avPlayer.play()
        }
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let duration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        if duration.isFinite {
            let elapsedTime = CMTimeGetSeconds(elapsedTime)
            updateTimeLabel(elapsedTime: elapsedTime, duration: duration)
        }
    }
    
    func sliderBeganTracking(slider: UISlider) {
        playerRateBeforeSeek = avPlayer.rate
        avPlayer.pause()
    }
    
    func sliderEndedTracking(slider: UISlider) {
        let videoDuration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
        
        avPlayer.seek(to: CMTimeMakeWithSeconds(elapsedTime, 100)) { (completed: Bool) -> Void in
            if self.playerRateBeforeSeek > 0 {
                self.avPlayer.play()
            }
        }
    }
    
    func sliderValueChanged(slider: UISlider) {
        let videoDuration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &playbackLikelyToKeepUpContext {
            if avPlayer.currentItem!.isPlaybackLikelyToKeepUp {
                loadingIndicatorView.stopAnimating()
            } else {
                loadingIndicatorView.startAnimating()
            }
        }
    }
    
    
    deinit {
        
        if timeObserver != nil {
        
            avPlayer.removeTimeObserver(timeObserver)
            avPlayer.removeObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp")
            
        }
        
        
        
    }
    
    @objc private func dragGestureActivated(gestureRecognized: UIPanGestureRecognizer) {
        
        let vel = gestureRecognized.velocity(in: self.view)
        
        if vel.x > 0 {
            
            self.tabBarController?.selectedIndex = 1
            
        } else {
            
            self.tabBarController?.selectedIndex = 3
            
        }
        
    }
    
//    // Force the view into landscape mode (which is how most video media is consumed.)
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.landscape
//    }
}
