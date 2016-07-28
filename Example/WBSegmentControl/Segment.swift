//
//  Segment.swift
//  WBSegmentControl
//
//  Created by 王继荣 on 7/28/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import WBSegmentControl

class TextSegment: NSObject, WBSegmentContentProtocol {

    var text: String!
    var otherAttr: String!
    
    var type: WBSegmentType {
        return WBSegmentType.Text(text)
    }
    
    init(text: String, otherAttr: String = "") {
        super.init()
        
        self.text = text
        self.otherAttr = otherAttr
    }
}

class IconSegment: NSObject, WBSegmentContentProtocol {
    
    var icon: UIImage!
    
    var type: WBSegmentType {
        return WBSegmentType.Icon(icon)
    }
    
    init(icon: UIImage) {
        super.init()
        
        self.icon = icon
    }
}
