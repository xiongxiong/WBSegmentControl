//
//  ViewController.swift
//  WBSegmentControl
//
//  Created by xiongxiong on 04/24/2016.
//  Copyright (c) 2016 xiongxiong. All rights reserved.
//

import UIKit
import WBSegmentControl

class ViewController2: UIViewController {
    
    let segmentCtrl_A = WBSegmentControl()
    let segmentCtrl_B = WBSegmentControl()
    let segmentCtrl_C = WBSegmentControl()
    let segmentCtrl_D = WBSegmentControl()
    let segmentCtrl_E = WBSegmentControl()
    let segmentCtrl_F = WBSegmentControl()
    let segmentCtrl_G = WBSegmentControl()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(segmentCtrl_A)
        segmentCtrl_A.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentControl]|", options: .alignAllLeading, metrics: nil, views: ["segmentControl": segmentCtrl_A]))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_A, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 8))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_A, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 40))
        segmentCtrl_A.segments = [
            TextSegment(text: "News China"),
            TextSegment(text: "Breaking News"),
            TextSegment(text: "World"),
            TextSegment(text: "Science"),
            TextSegment(text: "Entertainment & Arts"),
            TextSegment(text: "Finance"),
            TextSegment(text: "Video"),
            TextSegment(text: "Radio"),
            TextSegment(text: "Education"),
            TextSegment(text: "Sports"),
            TextSegment(text: "Weather"),
            TextSegment(text: "Headlines"),
        ]
        segmentCtrl_A.style = .rainbow
        segmentCtrl_A.rainbow_colors = [
            UIColor(red:0.91, green:0.18, blue:0.24, alpha:1.00),
            UIColor(red:1.00, green:0.71, blue:0.26, alpha:1.00),
            UIColor(red:0.47, green:0.78, blue:0.97, alpha:1.00)
        ]
        
        self.view.addSubview(segmentCtrl_B)
        segmentCtrl_B.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentControl]|", options: .alignAllLeading, metrics: nil, views: ["segmentControl": segmentCtrl_B]))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_B, attribute: .top, relatedBy: .equal, toItem: segmentCtrl_A, attribute: .bottom, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_B, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 40))
        segmentCtrl_B.segments = [
            IconSegment(icon: UIImage(named: "1")!),
            IconSegment(icon: UIImage(named: "2")!),
            IconSegment(icon: UIImage(named: "3")!),
            IconSegment(icon: UIImage(named: "4")!),
            IconSegment(icon: UIImage(named: "5")!),
            IconSegment(icon: UIImage(named: "6")!),
            IconSegment(icon: UIImage(named: "7")!),
            IconSegment(icon: UIImage(named: "8")!),
            IconSegment(icon: UIImage(named: "9")!),
        ]
        segmentCtrl_B.style = .strip
        segmentCtrl_B.rainbow_colors = [
            UIColor(red:0.91, green:0.18, blue:0.24, alpha:1.00),
            UIColor(red:1.00, green:0.71, blue:0.26, alpha:1.00),
            UIColor(red:0.47, green:0.78, blue:0.97, alpha:1.00)
        ]
        segmentCtrl_B.enableSlideway = false
        segmentCtrl_B.strip_range = .segment
        
        self.view.addSubview(segmentCtrl_C)
        segmentCtrl_C.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentControl]|", options: .alignAllLeading, metrics: nil, views: ["segmentControl": segmentCtrl_C]))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_C, attribute: .top, relatedBy: .equal, toItem: segmentCtrl_B, attribute: .bottom, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_C, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 40))
        segmentCtrl_C.segments = [
            TextSegment(text: "News China"),
            TextSegment(text: "Breaking News"),
            TextSegment(text: "World"),
            TextSegment(text: "Science"),
            TextSegment(text: "Entertainment & Arts"),
            TextSegment(text: "Finance"),
            TextSegment(text: "Video"),
            TextSegment(text: "Radio"),
            TextSegment(text: "Education"),
            TextSegment(text: "Sports"),
            TextSegment(text: "Weather"),
            TextSegment(text: "Headlines"),
        ]
        segmentCtrl_C.style = .arrow
        segmentCtrl_C.enableSlideway = true
        segmentCtrl_C.enableSeparator = true
        
        self.view.addSubview(segmentCtrl_D)
        segmentCtrl_D.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentControl]|", options: .alignAllLeading, metrics: nil, views: ["segmentControl": segmentCtrl_D]))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_D, attribute: .top, relatedBy: .equal, toItem: segmentCtrl_C, attribute: .bottom, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_D, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 40))
        segmentCtrl_D.segments = [
            TextSegment(text: "News China"),
            TextSegment(text: "Breaking News"),
            TextSegment(text: "World"),
            TextSegment(text: "Science"),
            TextSegment(text: "Entertainment & Arts"),
            TextSegment(text: "Finance"),
            TextSegment(text: "Video"),
            TextSegment(text: "Radio"),
            TextSegment(text: "Education"),
            TextSegment(text: "Sports"),
            TextSegment(text: "Weather"),
            TextSegment(text: "Headlines"),
        ]
        segmentCtrl_D.style = .arrowStrip
        
        self.view.addSubview(segmentCtrl_E)
        segmentCtrl_E.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentControl]|", options: .alignAllLeading, metrics: nil, views: ["segmentControl": segmentCtrl_E]))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_E, attribute: .top, relatedBy: .equal, toItem: segmentCtrl_D, attribute: .bottom, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_E, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 40))
        segmentCtrl_E.segments = [
            TextSegment(text: "News China"),
            TextSegment(text: "Breaking News"),
            TextSegment(text: "World"),
            TextSegment(text: "Science"),
            TextSegment(text: "Entertainment & Arts"),
            TextSegment(text: "Finance"),
            TextSegment(text: "Video"),
            TextSegment(text: "Radio"),
            TextSegment(text: "Education"),
            TextSegment(text: "Sports"),
            TextSegment(text: "Weather"),
            TextSegment(text: "Headlines"),
        ]
        segmentCtrl_E.style = .arrowStrip
        segmentCtrl_E.enableSlideway = false
        
        self.view.addSubview(segmentCtrl_F)
        segmentCtrl_F.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentControl]|", options: .alignAllLeading, metrics: nil, views: ["segmentControl": segmentCtrl_F]))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_F, attribute: .top, relatedBy: .equal, toItem: segmentCtrl_E, attribute: .bottom, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_F, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 40))
        segmentCtrl_F.segments = [
            TextSegment(text: "News China"),
            TextSegment(text: "Breaking News"),
            TextSegment(text: "World"),
            TextSegment(text: "Science"),
            TextSegment(text: "Entertainment & Arts"),
            TextSegment(text: "Finance"),
            TextSegment(text: "Video"),
            TextSegment(text: "Radio"),
            TextSegment(text: "Education"),
            TextSegment(text: "Sports"),
            TextSegment(text: "Weather"),
            TextSegment(text: "Headlines"),
        ]
        segmentCtrl_F.style = .cover
        
        self.view.addSubview(segmentCtrl_G)
        segmentCtrl_G.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentControl]|", options: .alignAllLeading, metrics: nil, views: ["segmentControl": segmentCtrl_G]))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_G, attribute: .top, relatedBy: .equal, toItem: segmentCtrl_F, attribute: .bottom, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: segmentCtrl_G, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 40))
        segmentCtrl_G.segments = [
            TextSegment(text: "News China"),
            TextSegment(text: "World"),
            TextSegment(text: "Science"),
        ]
        segmentCtrl_G.style = .strip
        segmentCtrl_G.nonScrollDistributionStyle = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentCtrl_A.selectedIndex = 0
        segmentCtrl_B.selectedIndex = 0
        segmentCtrl_C.selectedIndex = 0
        segmentCtrl_D.selectedIndex = 0
        segmentCtrl_E.selectedIndex = 0
        segmentCtrl_F.selectedIndex = 0
        segmentCtrl_G.selectedIndex = 0
    }
}

