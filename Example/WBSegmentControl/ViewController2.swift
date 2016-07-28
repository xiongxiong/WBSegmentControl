//
//  ViewController.swift
//  WBSegmentControl
//
//  Created by xiongxiong on 04/24/2016.
//  Copyright (c) 2016 xiongxiong. All rights reserved.
//

import UIKit
//import WBSegmentControl
import SnapKit
import SwiftHEXColors

class ViewController2: UIViewController {
    
    let segmentCtrl_A = WBSegmentControl()
    let segmentCtrl_B = WBSegmentControl()
    let segmentCtrl_C = WBSegmentControl()
    let segmentCtrl_D = WBSegmentControl()
    let segmentCtrl_E = WBSegmentControl()
    let segmentCtrl_F = WBSegmentControl()
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(segmentCtrl_A)
        segmentCtrl_A.snp_makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(8)
            make.height.equalTo(40)
        }
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
        segmentCtrl_A.style = .Rainbow
        segmentCtrl_A.rainbow_colors = [UIColor(hexString: "e72f3c")!, UIColor(hexString: "ffb642")!, UIColor(hexString: "79c7f8")!]
        
        self.view.addSubview(segmentCtrl_B)
        segmentCtrl_B.snp_makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(segmentCtrl_A.snp_bottom).offset(15)
            make.height.equalTo(40)
        }
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
        segmentCtrl_B.style = .Strip
        segmentCtrl_B.rainbow_colors = [UIColor(hexString: "e72f3c")!, UIColor(hexString: "ffb642")!, UIColor(hexString: "79c7f8")!]
        segmentCtrl_B.enableSlideway = false
        segmentCtrl_B.strip_range = .Segment
        
        self.view.addSubview(segmentCtrl_C)
        segmentCtrl_C.snp_makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(segmentCtrl_B.snp_bottom).offset(15)
            make.height.equalTo(40)
        }
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
        segmentCtrl_C.style = .Arrow
        segmentCtrl_C.enableSlideway = true
        segmentCtrl_C.enableSeparator = true
        
        self.view.addSubview(segmentCtrl_D)
        segmentCtrl_D.snp_makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(segmentCtrl_C.snp_bottom).offset(15)
            make.height.equalTo(40)
        }
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
        segmentCtrl_D.style = .ArrowStrip
        
        self.view.addSubview(segmentCtrl_E)
        segmentCtrl_E.snp_makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(segmentCtrl_C.snp_bottom).offset(15)
            make.height.equalTo(40)
        }
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
        segmentCtrl_E.style = .ArrowStrip
        segmentCtrl_E.enableSlideway = false
        
        self.view.addSubview(segmentCtrl_F)
        segmentCtrl_F.snp_makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(segmentCtrl_D.snp_bottom).offset(15)
            make.height.equalTo(40)
        }
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
        segmentCtrl_F.style = .Cover
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentCtrl_A.selectedIndex = 0
        segmentCtrl_B.selectedIndex = 0
        segmentCtrl_C.selectedIndex = 0
        segmentCtrl_D.selectedIndex = 0
        segmentCtrl_E.selectedIndex = 0
        segmentCtrl_F.selectedIndex = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
}

