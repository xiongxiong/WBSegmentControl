//
//  Segment.swift
//  WBSegmentControl
//
//  Created by 王继荣 on 7/28/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

public class TextSegment: NSObject, WBSegmentContentProtocol {
    
    public var text: String!
    public var otherAttr: String!
    
    public var type: WBSegmentType {
        return WBSegmentType.text(text)
    }
    
    public init(text: String, otherAttr: String = "") {
        super.init()
        
        self.text = text
        self.otherAttr = otherAttr
    }
}

public class IconSegment: NSObject, WBSegmentContentProtocol {
    
    public var icon: UIImage!
    
    public var type: WBSegmentType {
        return WBSegmentType.icon(icon)
    }
    
    public init(icon: UIImage) {
        super.init()
        
        self.icon = icon
    }
}
