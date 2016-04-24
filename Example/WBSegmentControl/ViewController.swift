//
//  ViewController.swift
//  WBSegmentControl
//
//  Created by xiongxiong on 04/24/2016.
//  Copyright (c) 2016 xiongxiong. All rights reserved.
//

import UIKit
import WBSegmentControl
import SnapKit
import SwiftHEXColors

class ViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        let segmentCtrl_A = WBSegmentControl()
        self.view.addSubview(segmentCtrl_A)
        segmentCtrl_A.snp_makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(8)
            make.height.equalTo(40)
        }
        segmentCtrl_A.segments = [
            WBSegmentControl.Segment(type: .Text("News China")),
            WBSegmentControl.Segment(type: .Text("Breaking News")),
            WBSegmentControl.Segment(type: .Text("World")),
            WBSegmentControl.Segment(type: .Text("Science")),
            WBSegmentControl.Segment(type: .Text("Entertainment & Arts")),
            WBSegmentControl.Segment(type: .Text("Finance")),
            WBSegmentControl.Segment(type: .Text("Video")),
            WBSegmentControl.Segment(type: .Text("Radio")),
            WBSegmentControl.Segment(type: .Text("Education")),
            WBSegmentControl.Segment(type: .Text("Sports")),
            WBSegmentControl.Segment(type: .Text("Weather")),
            WBSegmentControl.Segment(type: .Text("Headlines")),
        ]
        segmentCtrl_A.indicatorStyle = .Rainbow
        segmentCtrl_A.rainbow_colors = [UIColor(hexString: "e72f3c")!, UIColor(hexString: "ffb642")!, UIColor(hexString: "79c7f8")!]
        
        let segmentCtrl_B = WBSegmentControl()
        self.view.addSubview(segmentCtrl_B)
        segmentCtrl_B.snp_makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(segmentCtrl_A.snp_bottom).offset(15)
            make.height.equalTo(40)
        }
        segmentCtrl_B.segments = [
            WBSegmentControl.Segment(type: .Icon(UIImage(named: "1")!)),
            WBSegmentControl.Segment(type: .Icon(UIImage(named: "2")!)),
            WBSegmentControl.Segment(type: .Icon(UIImage(named: "3")!)),
            WBSegmentControl.Segment(type: .Icon(UIImage(named: "4")!)),
            WBSegmentControl.Segment(type: .Icon(UIImage(named: "5")!)),
            WBSegmentControl.Segment(type: .Icon(UIImage(named: "6")!)),
            WBSegmentControl.Segment(type: .Icon(UIImage(named: "7")!)),
            WBSegmentControl.Segment(type: .Icon(UIImage(named: "8")!)),
            WBSegmentControl.Segment(type: .Icon(UIImage(named: "9")!)),
        ]
        segmentCtrl_B.indicatorStyle = .Strip
        segmentCtrl_B.rainbow_colors = [UIColor(hexString: "e72f3c")!, UIColor(hexString: "ffb642")!, UIColor(hexString: "79c7f8")!]
        segmentCtrl_B.enableSlideway = false
        segmentCtrl_B.strip_range = .Segment
        
        let segmentCtrl_C = WBSegmentControl()
        self.view.addSubview(segmentCtrl_C)
        segmentCtrl_C.snp_makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(segmentCtrl_B.snp_bottom).offset(15)
            make.height.equalTo(40)
        }
        segmentCtrl_C.segments = [
            WBSegmentControl.Segment(type: .Text("News China")),
            WBSegmentControl.Segment(type: .Text("Breaking News")),
            WBSegmentControl.Segment(type: .Text("World")),
            WBSegmentControl.Segment(type: .Text("Science")),
            WBSegmentControl.Segment(type: .Text("Entertainment & Arts")),
            WBSegmentControl.Segment(type: .Text("Finance")),
            WBSegmentControl.Segment(type: .Text("Video")),
            WBSegmentControl.Segment(type: .Text("Radio")),
            WBSegmentControl.Segment(type: .Text("Education")),
            WBSegmentControl.Segment(type: .Text("Sports")),
            WBSegmentControl.Segment(type: .Text("Weather")),
            WBSegmentControl.Segment(type: .Text("Headlines")),
        ]
        segmentCtrl_C.indicatorStyle = .Arrow
        segmentCtrl_C.enableSlideway = true
        segmentCtrl_C.enableSeparator = true
        
        let segmentCtrl_D = WBSegmentControl()
        self.view.addSubview(segmentCtrl_D)
        segmentCtrl_D.snp_makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(segmentCtrl_C.snp_bottom).offset(15)
            make.height.equalTo(40)
        }
        segmentCtrl_D.segments = [
            WBSegmentControl.Segment(type: .Text("News China")),
            WBSegmentControl.Segment(type: .Text("Breaking News")),
            WBSegmentControl.Segment(type: .Text("World")),
            WBSegmentControl.Segment(type: .Text("Science")),
            WBSegmentControl.Segment(type: .Text("Entertainment & Arts")),
            WBSegmentControl.Segment(type: .Text("Finance")),
            WBSegmentControl.Segment(type: .Text("Video")),
            WBSegmentControl.Segment(type: .Text("Radio")),
            WBSegmentControl.Segment(type: .Text("Education")),
            WBSegmentControl.Segment(type: .Text("Sports")),
            WBSegmentControl.Segment(type: .Text("Weather")),
            WBSegmentControl.Segment(type: .Text("Headlines")),
        ]
        segmentCtrl_D.indicatorStyle = .ArrowStrip
        
        let segmentCtrl_E = WBSegmentControl()
        self.view.addSubview(segmentCtrl_E)
        segmentCtrl_E.snp_makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(segmentCtrl_C.snp_bottom).offset(15)
            make.height.equalTo(40)
        }
        segmentCtrl_E.segments = [
            WBSegmentControl.Segment(type: .Text("News China")),
            WBSegmentControl.Segment(type: .Text("Breaking News")),
            WBSegmentControl.Segment(type: .Text("World")),
            WBSegmentControl.Segment(type: .Text("Science")),
            WBSegmentControl.Segment(type: .Text("Entertainment & Arts")),
            WBSegmentControl.Segment(type: .Text("Finance")),
            WBSegmentControl.Segment(type: .Text("Video")),
            WBSegmentControl.Segment(type: .Text("Radio")),
            WBSegmentControl.Segment(type: .Text("Education")),
            WBSegmentControl.Segment(type: .Text("Sports")),
            WBSegmentControl.Segment(type: .Text("Weather")),
            WBSegmentControl.Segment(type: .Text("Headlines")),
        ]
        segmentCtrl_E.indicatorStyle = .ArrowStrip
        segmentCtrl_E.enableSlideway = false
        
        let segmentCtrl_F = WBSegmentControl()
        self.view.addSubview(segmentCtrl_F)
        segmentCtrl_F.snp_makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(segmentCtrl_D.snp_bottom).offset(15)
            make.height.equalTo(40)
        }
        segmentCtrl_F.segments = [
            WBSegmentControl.Segment(type: .Text("News China")),
            WBSegmentControl.Segment(type: .Text("Breaking News")),
            WBSegmentControl.Segment(type: .Text("World")),
            WBSegmentControl.Segment(type: .Text("Science")),
            WBSegmentControl.Segment(type: .Text("Entertainment & Arts")),
            WBSegmentControl.Segment(type: .Text("Finance")),
            WBSegmentControl.Segment(type: .Text("Video")),
            WBSegmentControl.Segment(type: .Text("Radio")),
            WBSegmentControl.Segment(type: .Text("Education")),
            WBSegmentControl.Segment(type: .Text("Sports")),
            WBSegmentControl.Segment(type: .Text("Weather")),
            WBSegmentControl.Segment(type: .Text("Headlines")),
        ]
        segmentCtrl_F.indicatorStyle = .Cover
    }
}

