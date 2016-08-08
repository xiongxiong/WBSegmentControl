//
//  CustomSegmentControl2.swift
//  TrafficSecretary
//
//  Created by 王继荣 on 4/9/16.
//  Copyright © 2016 wonderbear. All rights reserved.
//

import UIKit

// MARK: WBSegmentControlDelegate
public protocol WBSegmentControlDelegate {
    func segmentControl(segmentControl: WBSegmentControl, selectIndex newIndex: Int, oldIndex: Int)
}

// MARK: WBInnerSegmentDelegate
protocol WBInnerSegmentDelegate {
    func didSelect(location: CGPoint)
}

// MARK: WBSegmentControl
public class WBSegmentControl: UIControl {
    
    // MARK: Configuration - Content
    public var segments: [WBSegmentContentProtocol] = [] {
        didSet {
            innerSegments = segments.map({ (content) -> WBInnerSegment in
                let innerSegment = WBInnerSegment(content: content)
                innerSegment.delegate = self
                return innerSegment
            })
            self.setNeedsLayout()
            if segments.count == 0 {
                selectedIndex = -1
            }
        }
    }
    var innerSegments: [WBInnerSegment] = []
    
    // MARK: Configuration - Interaction
    public var delegate: WBSegmentControlDelegate?
    public var selectedIndex: Int = -1 {
        didSet {
            if selectedIndex != oldValue && validIndex(selectedIndex) {
                selectedIndexChanged(selectedIndex, oldIndex: oldValue)
                delegate?.segmentControl(self, selectIndex: selectedIndex, oldIndex: oldValue)
            }
        }
    }
    public var selectedSegment: WBSegmentContentProtocol? {
        return validIndex(selectedIndex) ? segments[selectedIndex] : nil
    }
    
    // MARK: Configuration - Appearance
    public var style: WBSegmentIndicatorStyle = .Rainbow
    public var nonScrollDistributionStyle: WBSegmentNonScrollDistributionStyle = .Average
    public var enableSeparator: Bool = false
    public var separatorColor: UIColor = UIColor.blackColor()
    public var separatorWidth: CGFloat = 9
    public var separatorEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
    public var enableSlideway: Bool = false
    public var slidewayHeight: CGFloat = 1
    public var slidewayColor: UIColor = UIColor.lightGrayColor()
    public var enableAnimation: Bool = true
    public var animationDuration: NSTimeInterval = 0.15
    public var contentBackgroundColor: UIColor = UIColor.whiteColor()
    public var segmentMinWidth: CGFloat = 50
    public var segmentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    public var segmentTextBold: Bool = true
    public var segmentTextFontSize: CGFloat = 12
    public var segmentTextForegroundColor: UIColor = UIColor.grayColor()
    public var segmentTextForegroundColorSelected: UIColor = UIColor.blackColor()
    
    // Settings - Cover
    public typealias CoverRange = WBSegmentIndicatorRange
    
    public var cover_range: CoverRange = .Segment
    public var cover_opacity: Float = 0.2
    public var cover_color: UIColor = UIColor.blackColor()
    
    // Settings - Strip
    public typealias StripRange = WBSegmentIndicatorRange
    public typealias StripLocation = WBSegmentIndicatorLocation
    
    public var strip_range: StripRange = .Content
    public var strip_location: StripLocation = .Down
    public var strip_color: UIColor = UIColor.orangeColor()
    public var strip_height: CGFloat = 3
    
    // Settings - Rainbow
    public typealias RainbowLocation = WBSegmentIndicatorLocation
    
    public var rainbow_colors: [UIColor] = []
    public var rainbow_height: CGFloat = 3
    public var rainbow_roundCornerRadius: CGFloat = 4
    public var rainbow_location: RainbowLocation = .Down
    public var rainbow_outsideColor: UIColor = UIColor.grayColor()
    
    // Settings - Arrow
    public typealias ArrowLocation = WBSegmentIndicatorLocation
    
    public var arrow_size: CGSize = CGSizeMake(6, 6)
    public var arrow_location: ArrowLocation = .Down
    public var arrow_color: UIColor = UIColor.orangeColor()
    
    // Settings - ArrowStrip
    public typealias ArrowStripLocation = WBSegmentIndicatorLocation
    public typealias ArrowStripRange = WBSegmentIndicatorRange
    
    public var arrowStrip_location: ArrowStripLocation = .Up
    public var arrowStrip_color: UIColor = UIColor.orangeColor()
    public var arrowStrip_arrowSize: CGSize = CGSizeMake(6, 6)
    public var arrowStrip_stripHeight: CGFloat = 2
    public var arrowStrip_stripRange: ArrowStripRange = .Content
    
    // MARK: Inner properties
    private var scrollView: UIScrollView!
    private var layerCover: CALayer = CALayer()
    private var layerStrip: CALayer = CALayer()
    private var layerArrow: CALayer = CALayer()
    private var segmentControlContentWidth: CGFloat {
        let sum = self.innerSegments.reduce(0, combine: { (max_x, segment) -> CGFloat in
            return max(max_x, CGRectGetMaxX(segment.segmentFrame))
        })
        return sum + ((self.enableSeparator && self.style != .Rainbow) ? self.separatorWidth / 2 : 0)
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.scrollView = { [unowned self] in
            let scrollView = UIScrollView()
            self.addSubview(scrollView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.backgroundColor = self.contentBackgroundColor
            return scrollView
            }()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override methods
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.layer.sublayers?.removeAll()
        self.scrollView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        // Compute Segment Size
        for (index, segment) in self.innerSegments.enumerate() {
            segment.contentSize = self.segmentContentSize(segment)
            segment.segmentWidth = max(segment.contentSize.width + self.segmentEdgeInsets.left + self.segmentEdgeInsets.right, self.segmentMinWidth)
            segment.segmentFrame = self.segmentFrame(index)
        }
        
        // Adjust Control Content Size & Segment Size
        self.scrollView.contentSize = CGSizeMake(self.segmentControlContentWidth, self.scrollView.frame.height)
        if self.scrollView.contentSize.width < self.scrollView.frame.width {
            switch self.nonScrollDistributionStyle {
            case .Center:
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: (self.scrollView.frame.width - self.scrollView.contentSize.width) / 2, bottom: 0, right: 0)
            case .Left:
                self.scrollView.contentInset = UIEdgeInsetsZero
            case .Right:
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: self.scrollView.frame.width - self.scrollView.contentSize.width, bottom: 0, right: 0)
            case .Average:
                self.scrollView.contentInset = UIEdgeInsetsZero
                self.scrollView.contentSize = self.scrollView.frame.size
                var averageWidth: CGFloat = (self.scrollView.frame.width - (self.enableSeparator && self.style != .Rainbow ? CGFloat(self.innerSegments.count) * self.separatorWidth : 0)) / CGFloat(self.innerSegments.count)
                let largeSegments = self.innerSegments.filter({ (segment) -> Bool in
                    return segment.segmentWidth >= averageWidth
                })
                let smallSegments = self.innerSegments.filter({ (segment) -> Bool in
                    return segment.segmentWidth < averageWidth
                })
                let sumLarge = largeSegments.reduce(0, combine: { (total, segment) -> CGFloat in
                    return total + segment.segmentWidth
                })
                averageWidth = (self.scrollView.frame.width - (self.enableSeparator && self.style != .Rainbow ? CGFloat(self.innerSegments.count) * self.separatorWidth : 0) - sumLarge) / CGFloat(smallSegments.count)
                for segment in smallSegments {
                    segment.segmentWidth = averageWidth
                }
                for (index, segment) in self.innerSegments.enumerate() {
                    segment.segmentFrame = self.segmentFrame(index)
                    segment.segmentFrame.origin.x += self.separatorWidth / 2
                }
            }
        } else {
            self.scrollView.contentInset = UIEdgeInsetsZero
        }
        
        // Create Segment Views
        innerSegments.forEach { (segment) in
            scrollView.addSubview(segment)
            segment.frame = segment.segmentFrame
        }
        
        // Add Segment SubLayers
        for (index, segment) in self.innerSegments.enumerate() {
            let content_x = segment.segmentFrame.origin.x + (segment.segmentFrame.width - segment.contentSize.width) / 2
            let content_y = (self.scrollView.frame.height - segment.contentSize.height) / 2
            let content_frame = CGRectMake(content_x, content_y, segment.contentSize.width, segment.contentSize.height)
            
            // Add Decoration Layer
            switch self.style {
            case .Rainbow:
                let layerStrip = CALayer()
                layerStrip.frame = CGRectMake(segment.segmentFrame.origin.x, index == self.selectedIndex ? 0 : segment.segmentFrame.height - self.rainbow_height, segment.segmentFrame.width, index == self.selectedIndex ? self.scrollView.frame.height : self.rainbow_height)
                if self.rainbow_colors.isEmpty == false {
                    layerStrip.backgroundColor = self.rainbow_colors[index % self.rainbow_colors.count].CGColor
                }
                self.scrollView.layer.addSublayer(layerStrip)
                self.switchRoundCornerForLayer(layerStrip, isRoundCorner: index == self.selectedIndex)
                segment.layerStrip = layerStrip
            default:
                break
            }
            
            // Add Content Layer
            switch segment.content.type {
            case let .Text(text):
                let layerText = CATextLayer()
                layerText.string = text
                let font = segmentTextBold ? UIFont.boldSystemFontOfSize(self.segmentTextFontSize) : UIFont.systemFontOfSize(self.segmentTextFontSize)
                layerText.font = CGFontCreateWithFontName(NSString(string:font.fontName))
                layerText.fontSize = font.pointSize
                layerText.frame = content_frame
                layerText.alignmentMode = kCAAlignmentCenter
                layerText.truncationMode = kCATruncationEnd
                layerText.contentsScale = UIScreen.mainScreen().scale
                layerText.foregroundColor = index == self.selectedIndex ? self.segmentTextForegroundColorSelected.CGColor : self.segmentTextForegroundColor.CGColor
                self.scrollView.layer.addSublayer(layerText)
                segment.layerText = layerText
            case let .Icon(icon):
                let layerIcon = CALayer()
                let image = icon
                layerIcon.frame = content_frame
                layerIcon.contents = image.CGImage
                self.scrollView.layer.addSublayer(layerIcon)
                segment.layerIcon = layerIcon
            }
        }
        
        // Add Indicator Layer
        let initLayerSeparator = { [unowned self] in
            let layerSeparator = CALayer()
            layerSeparator.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)
            layerSeparator.backgroundColor = self.separatorColor.CGColor
            
            let layerMask = CAShapeLayer()
            layerMask.fillColor = UIColor.whiteColor().CGColor
            let maskPath = UIBezierPath()
            for (index, segment) in self.innerSegments.enumerate() {
                index < self.innerSegments.count - 1 ? maskPath.appendPath(UIBezierPath(rect: CGRectMake(CGRectGetMaxX(segment.segmentFrame) + self.separatorEdgeInsets.left, self.separatorEdgeInsets.top, self.separatorWidth - self.separatorEdgeInsets.left - self.separatorEdgeInsets.right, self.scrollView.frame.height - self.separatorEdgeInsets.top - self.separatorEdgeInsets.bottom))) : ()
            }
            layerMask.path = maskPath.CGPath
            layerSeparator.mask = layerMask
            self.scrollView.layer.addSublayer(layerSeparator)
        }
        let initLayerCover = { [unowned self] in
            self.layerCover.frame = self.indicatorCoverFrame(self.selectedIndex)
            self.layerCover.backgroundColor = self.cover_color.CGColor
            self.layerCover.opacity = self.cover_opacity
            self.scrollView.layer.addSublayer(self.layerCover)
        }
        let addLayerOutside = { [unowned self] in
            let outsideLayerLeft = CALayer()
            outsideLayerLeft.frame = CGRectMake(-1 * self.scrollView.frame.width, self.scrollView.frame.height - self.rainbow_height, self.scrollView.frame.width, self.rainbow_height)
            outsideLayerLeft.backgroundColor = self.rainbow_outsideColor.CGColor
            self.scrollView.layer.addSublayer(outsideLayerLeft)
            
            let outsideLayerRight = CALayer()
            outsideLayerRight.frame = CGRectMake(self.scrollView.contentSize.width, self.scrollView.frame.height - self.rainbow_height, self.scrollView.frame.width, self.rainbow_height)
            outsideLayerRight.backgroundColor = self.rainbow_outsideColor.CGColor
            self.scrollView.layer.addSublayer(outsideLayerRight)
        }
        let addLayerSlideway = { [unowned self] (slidewayPosition: CGFloat, slidewayHeight: CGFloat, slidewayColor: UIColor) in
            let layerSlideway = CALayer()
            layerSlideway.frame = CGRectMake(-1 * self.scrollView.frame.width, slidewayPosition - slidewayHeight / 2, self.scrollView.contentSize.width + self.scrollView.frame.width * 2, slidewayHeight)
            layerSlideway.backgroundColor = slidewayColor.CGColor
            self.scrollView.layer.addSublayer(layerSlideway)
        }
        let initLayerStrip = { [unowned self] (stripFrame: CGRect, stripColor: UIColor) in
            self.layerStrip.frame = stripFrame
            self.layerStrip.backgroundColor = stripColor.CGColor
            self.scrollView.layer.addSublayer(self.layerStrip)
        }
        let initLayerArrow = { [unowned self] (arrowFrame: CGRect, arrowLocation: WBSegmentIndicatorLocation, arrowColor: UIColor) in
            self.layerArrow.frame = arrowFrame
            self.layerArrow.backgroundColor = arrowColor.CGColor
            
            let layerMask = CAShapeLayer()
            layerMask.fillColor = UIColor.whiteColor().CGColor
            let maskPath = UIBezierPath()
            var pointA = CGPointZero
            var pointB = CGPointZero
            var pointC = CGPointZero
            switch arrowLocation {
            case .Up:
                pointA = CGPointMake(0, 0)
                pointB = CGPointMake(self.layerArrow.bounds.width, 0)
                pointC = CGPointMake(self.layerArrow.bounds.width / 2, self.layerArrow.bounds.height)
            case .Down:
                pointA = CGPointMake(0, self.layerArrow.bounds.height)
                pointB = CGPointMake(self.layerArrow.bounds.width, self.layerArrow.bounds.height)
                pointC = CGPointMake(self.layerArrow.bounds.width / 2, 0)
            }
            maskPath.moveToPoint(pointA)
            maskPath.addLineToPoint(pointB)
            maskPath.addLineToPoint(pointC)
            maskPath.closePath()
            layerMask.path = maskPath.CGPath
            self.layerArrow.mask = layerMask
            
            self.scrollView.layer.addSublayer(self.layerArrow)
        }
        switch self.style {
        case .Cover:
            initLayerCover()
            self.enableSeparator ? initLayerSeparator() : ()
        case .Strip:
            let strip_frame = self.indicatorStripFrame(self.selectedIndex, stripHeight: self.strip_height, stripLocation: self.strip_location, stripRange: self.strip_range)
            self.enableSlideway ? addLayerSlideway(CGRectGetMidY(strip_frame), self.slidewayHeight, self.slidewayColor) : ()
            initLayerStrip(strip_frame, self.strip_color)
            self.enableSeparator ? initLayerSeparator() : ()
        case .Rainbow:
            addLayerOutside()
        case .Arrow:
            let arrow_frame = self.indicatorArrowFrame(self.selectedIndex, arrowLocation: self.arrow_location, arrowSize: self.arrow_size)
            var slideway_y: CGFloat = 0
            switch self.arrow_location {
            case .Up:
                slideway_y = arrow_frame.origin.y + self.slidewayHeight / 2
            case .Down:
                slideway_y = arrow_frame.maxY - self.slidewayHeight / 2
            }
            self.enableSlideway ? addLayerSlideway(slideway_y, self.slidewayHeight, self.slidewayColor) : ()
            initLayerArrow(arrow_frame, self.arrow_location, self.arrow_color)
            self.enableSeparator ? initLayerSeparator() : ()
        case .ArrowStrip:
            let strip_frame = self.indicatorStripFrame(self.selectedIndex, stripHeight: self.arrowStrip_stripHeight, stripLocation: self.arrowStrip_location, stripRange: self.arrowStrip_stripRange)
            self.enableSlideway ? addLayerSlideway(CGRectGetMidY(strip_frame), self.slidewayHeight, self.slidewayColor) : ()
            initLayerStrip(strip_frame, self.arrowStrip_color)
            let arrow_frame = self.indicatorArrowFrame(self.selectedIndex, arrowLocation: self.arrowStrip_location, arrowSize: self.arrowStrip_arrowSize)
            initLayerArrow(arrow_frame, self.arrowStrip_location, self.arrowStrip_color)
            self.enableSeparator ? initLayerSeparator() : ()
        }
    }
    
    // MARK: Custom methods
    func selectedIndexChanged(newIndex: Int, oldIndex: Int) {
        if self.enableAnimation && validIndex(oldIndex) {
            CATransaction.begin()
            CATransaction.setAnimationDuration(self.animationDuration)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
            CATransaction.setCompletionBlock({ [unowned self] in
                switch self.style {
                case .Rainbow:
                    if self.validIndex(oldIndex) {
                        self.switchRoundCornerForLayer(self.innerSegments[oldIndex].layerStrip!, isRoundCorner: false)
                    }
                default:
                    break
                }
                })
            self.scrollView.contentSize.width > self.scrollView.frame.width ? self.scrollToSegment(newIndex) : ()
            self.didSelectedIndexChanged(newIndex, oldIndex: oldIndex)
            CATransaction.commit()
        } else {
            self.didSelectedIndexChanged(newIndex, oldIndex: oldIndex)
        }
        
        self.sendActionsForControlEvents(.ValueChanged)
    }
    
    func didSelectedIndexChanged(newIndex: Int, oldIndex: Int) {
        switch style {
        case .Cover:
            self.layerCover.actions = nil
            self.layerCover.frame = self.indicatorCoverFrame(newIndex)
        case .Strip:
            self.layerStrip.actions = nil
            self.layerStrip.frame = self.indicatorStripFrame(newIndex, stripHeight: self.strip_height, stripLocation: self.strip_location, stripRange: self.strip_range)
        case .Rainbow:
            if validIndex(oldIndex), let old_StripLayer = self.innerSegments[oldIndex].layerStrip {
                let old_StripFrame = old_StripLayer.frame
                old_StripLayer.frame = CGRectMake(old_StripFrame.origin.x, self.scrollView.frame.height - self.strip_height, old_StripFrame.width, self.strip_height)
            }
            if let new_StripLayer = self.innerSegments[newIndex].layerStrip {
                let new_StripFrame = new_StripLayer.frame
                new_StripLayer.frame = CGRectMake(new_StripFrame.origin.x, 0, new_StripFrame.width, self.scrollView.frame.height)
                self.switchRoundCornerForLayer(new_StripLayer, isRoundCorner: true)
            }
        case .Arrow:
            self.layerArrow.actions = nil
            self.layerArrow.frame = self.indicatorArrowFrame(newIndex, arrowLocation: self.arrow_location, arrowSize: self.arrow_size)
        case .ArrowStrip:
            self.layerStrip.actions = nil
            self.layerStrip.frame = self.indicatorStripFrame(newIndex, stripHeight: self.arrowStrip_stripHeight, stripLocation: self.arrowStrip_location, stripRange: self.arrowStrip_stripRange)
            self.layerArrow.actions = nil
            self.layerArrow.frame = self.indicatorArrowFrame(newIndex, arrowLocation: self.arrowStrip_location, arrowSize: self.arrowStrip_arrowSize)
        }
        
        if validIndex(oldIndex) {
            switch self.innerSegments[oldIndex].content.type {
            case .Text:
                if let old_contentLayer = self.innerSegments[oldIndex].layerText as? CATextLayer {
                    old_contentLayer.foregroundColor = self.segmentTextForegroundColor.CGColor
                }
            default:
                break
            }
        }
        switch self.innerSegments[newIndex].content.type {
        case .Text:
            if let new_contentLayer = self.innerSegments[newIndex].layerText as? CATextLayer {
                new_contentLayer.foregroundColor = self.segmentTextForegroundColorSelected.CGColor
            }
        default:
            break
        }
    }
    
    func switchRoundCornerForLayer(layer: CALayer, isRoundCorner: Bool) {
        if isRoundCorner {
            let layerMask = CAShapeLayer()
            layerMask.fillColor = UIColor.whiteColor().CGColor
            layerMask.path = UIBezierPath(roundedRect: CGRect(origin: CGPointZero, size: layer.frame.size), byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSizeMake(self.rainbow_roundCornerRadius, self.rainbow_roundCornerRadius)).CGPath
            layer.mask = layerMask
        } else {
            layer.mask = nil
        }
    }
    
    func scrollToSegment(index: Int) {
        let segmentFrame = self.innerSegments[index].segmentFrame
        let targetRect = CGRectMake(segmentFrame.origin.x - (self.scrollView.frame.width - segmentFrame.width) / 2, 0, self.scrollView.frame.width, self.scrollView.frame.height)
        self.scrollView.scrollRectToVisible(targetRect, animated: true)
    }
    
    func segmentContentSize(segment: WBInnerSegment) -> CGSize {
        var size = CGSizeZero
        switch segment.content.type {
        case let .Text(text):
            size = (text as NSString).sizeWithAttributes([
                NSFontAttributeName: segmentTextBold ? UIFont.boldSystemFontOfSize(self.segmentTextFontSize) : UIFont.systemFontOfSize(self.segmentTextFontSize)
                ])
        case let .Icon(icon):
            size = icon.size
        }
        return CGSizeMake(ceil(size.width), ceil(size.height))
    }
    
    func segmentFrame(index: Int) -> CGRect {
        var segmentOffset: CGFloat = (self.enableSeparator && self.style != .Rainbow ? self.separatorWidth / 2 : 0)
        for (idx, segment) in self.innerSegments.enumerate() {
            if idx == index {
                break
            } else {
                segmentOffset += segment.segmentWidth + (self.enableSeparator && self.style != .Rainbow ? self.separatorWidth : 0)
            }
        }
        return CGRectMake(segmentOffset , 0, self.innerSegments[index].segmentWidth, self.scrollView.frame.height)
    }
    
    func indicatorCoverFrame(index: Int) -> CGRect {
        if validIndex(index) {
            var box_x: CGFloat = self.innerSegments[index].segmentFrame.origin.x
            var box_width: CGFloat = 0
            switch self.cover_range {
            case .Content:
                box_x += (self.innerSegments[index].segmentWidth - self.innerSegments[index].contentSize.width) / 2
                box_width = self.innerSegments[index].contentSize.width
            case .Segment:
                box_width = self.innerSegments[index].segmentWidth
            }
            return CGRectMake(box_x, 0, box_width, self.scrollView.frame.height)
        } else {
            return CGRectZero
        }
    }
    
    func indicatorStripFrame(index: Int, stripHeight: CGFloat, stripLocation: WBSegmentIndicatorLocation, stripRange: WBSegmentIndicatorRange) -> CGRect {
        if validIndex(index) {
            var strip_x: CGFloat = self.innerSegments[index].segmentFrame.origin.x
            var strip_y: CGFloat = 0
            var strip_width: CGFloat = 0
            switch stripLocation {
            case .Down:
                strip_y = self.innerSegments[index].segmentFrame.height - stripHeight
            case .Up:
                strip_y = 0
            }
            switch stripRange {
            case .Content:
                strip_width = self.innerSegments[index].contentSize.width
                strip_x += (self.innerSegments[index].segmentWidth - strip_width) / 2
            case .Segment:
                strip_width = self.innerSegments[index].segmentWidth
            }
            return CGRectMake(strip_x, strip_y, strip_width, stripHeight)
        } else {
            return CGRectZero
        }
    }
    
    func indicatorArrowFrame(index: Int, arrowLocation: WBSegmentIndicatorLocation, arrowSize: CGSize) -> CGRect {
        if validIndex(index) {
            let arrow_x: CGFloat = self.innerSegments[index].segmentFrame.origin.x + (self.innerSegments[index].segmentFrame.width - arrowSize.width) / 2
            var arrow_y: CGFloat = 0
            switch arrowLocation {
            case .Up:
                arrow_y = 0
            case .Down:
                arrow_y = self.innerSegments[index].segmentFrame.height - self.arrow_size.height
            }
            return CGRectMake(arrow_x, arrow_y, arrowSize.width, arrowSize.height)
        } else {
            return CGRectZero
        }
    }
    
    func indexForTouch(location: CGPoint) -> Int {
        var touch_offset_x = location.x
        var touch_index = 0
        for (index, segment) in self.innerSegments.enumerate() {
            touch_offset_x -= segment.segmentWidth + (self.enableSeparator && self.style != .Rainbow ? self.separatorWidth : 0)
            if touch_offset_x < 0 {
                touch_index = index
                break
            }
        }
        return touch_index
    }
    
    func validIndex(index: Int) -> Bool {
        return index >= 0 && index < segments.count
    }
}

extension WBSegmentControl: WBInnerSegmentDelegate {
    func didSelect(location: CGPoint) {
        selectedIndex = indexForTouch(location)
    }
}

public protocol WBSegmentContentProtocol {
    
    var type: WBSegmentType { get }
}

class WBInnerSegment: UIView {
    
    let content: WBSegmentContentProtocol
    var delegate: WBInnerSegmentDelegate?
    
    var segmentFrame: CGRect = CGRectZero
    var segmentWidth: CGFloat = 0
    var contentSize: CGSize = CGSizeZero
    
    var layerText: CALayer!
    var layerIcon: CALayer!
    var layerStrip: CALayer!
    
    init(content: WBSegmentContentProtocol) {
        self.content = content
        super.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        delegate?.didSelect(center)
    }
}

public enum WBSegmentType {
    case Text(String)
    case Icon(UIImage)
}

public enum WBSegmentIndicatorStyle {
    case Cover, Strip, Rainbow, Arrow, ArrowStrip
}

public enum WBSegmentIndicatorLocation {
    case Up, Down
}

public enum WBSegmentIndicatorRange {
    case Content, Segment
}

public enum WBSegmentNonScrollDistributionStyle {
    case Center, Left, Right, Average
}
