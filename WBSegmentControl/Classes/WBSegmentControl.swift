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
    func segmentControl(segmentControl: WBSegmentControl, didSelectIndex index: Int)
}

// MARK: WBSegmentControl
public class WBSegmentControl: UIControl {
    
    // MARK: Configuration - Content
    public var segments: [Segment] = [Segment]() {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: Configuration - Interaction
    public var delegate: WBSegmentControlDelegate?
    public var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex != oldValue {
                self.selectedIndexChanged(selectedIndex, oldIndex: oldValue)
            }
        }
    }
    
    // MARK: Configuration - Appearance
    public var indicatorStyle: IndicatorStyle = .Rainbow
    public var nonScrollDistributionStyle: NonScrollDistributionStyle = .Average
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
    public var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    public var segmentMinWidth: CGFloat = 50
    public var segmentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    public var segmentTextFontSize: CGFloat = 12
    public var segmentTextForegroundColor: UIColor = UIColor.grayColor()
    public var segmentTextForegroundColorSelected: UIColor = UIColor.blackColor()
    
    // Settings - Cover
    public typealias CoverRange = IndicatorRange
    
    public var cover_range: CoverRange = .Segment
    public var cover_opacity: Float = 0.2
    public var cover_color: UIColor = UIColor.blackColor()
    
    // Settings - Strip
    public typealias StripRange = IndicatorRange
    public typealias StripLocation = IndicatorLocation
    
    public var strip_range: StripRange = .Content
    public var strip_location: StripLocation = .Down
    public var strip_color: UIColor = UIColor.orangeColor()
    public var strip_height: CGFloat = 3
    
    // Settings - Rainbow
    public typealias RainbowLocation = IndicatorLocation
    
    public var rainbow_colors: [UIColor] = []
    public var rainbow_height: CGFloat = 3
    public var rainbow_roundCornerRadius: CGFloat = 4
    public var rainbow_location: RainbowLocation = .Down
    public var rainbow_outsideColor: UIColor = UIColor.grayColor()
    
    // Settings - Arrow
    public typealias ArrowLocation = IndicatorLocation
    
    public var arrow_size: CGSize = CGSizeMake(6, 6)
    public var arrow_location: ArrowLocation = .Down
    public var arrow_color: UIColor = UIColor.orangeColor()
    
    // Settings - ArrowStrip
    public typealias ArrowStripLocation = IndicatorLocation
    public typealias ArrowStripRange = IndicatorRange
    
    public var arrowStrip_location: ArrowStripLocation = .Up
    public var arrowStrip_color: UIColor = UIColor.orangeColor()
    public var arrowStrip_arrowSize: CGSize = CGSizeMake(6, 6)
    public var arrowStrip_stripHeight: CGFloat = 2
    public var arrowStrip_stripRange: ArrowStripRange = .Content
    
    // MARK: Inner properties
    private var scrollView: UIScrollView!
    private var layerCover: CALayer!
    private var layerStrip: CALayer!
    private var layerArrow: CALayer!
    private var segmentControlContentWidth: CGFloat {
        let sum = self.segments.reduce(0, combine: { (max_x, segment) -> CGFloat in
            return max(max_x, CGRectGetMaxX(segment.segmentFrame))
        })
        return sum + ((self.enableSeparator && self.indicatorStyle != .Rainbow) ? self.separatorWidth / 2 : 0)
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.scrollView = { [unowned self] in
            let scrollView = UIScrollView()
            self.addSubview(scrollView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: self.contentEdgeInsets.top))
            self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -1 * self.contentEdgeInsets.bottom))
            self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: self.contentEdgeInsets.left))
            self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -1 * self.contentEdgeInsets.right))
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
        
        // Compute Segment Size
        for (index, segment) in self.segments.enumerate() {
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
                var averageWidth: CGFloat = (self.scrollView.frame.width - (self.enableSeparator && self.indicatorStyle != .Rainbow ? CGFloat(self.segments.count) * self.separatorWidth : 0)) / CGFloat(self.segments.count)
                let largeSegments = self.segments.filter({ (segment) -> Bool in
                    return segment.segmentWidth >= averageWidth
                })
                let smallSegments = self.segments.filter({ (segment) -> Bool in
                    return segment.segmentWidth < averageWidth
                })
                let sumLarge = largeSegments.reduce(0, combine: { (total, segment) -> CGFloat in
                    return total + segment.segmentWidth
                })
                averageWidth = (self.scrollView.frame.width - (self.enableSeparator && self.indicatorStyle != .Rainbow ? CGFloat(self.segments.count) * self.separatorWidth : 0) - sumLarge) / CGFloat(smallSegments.count)
                for segment in smallSegments {
                    segment.segmentWidth = averageWidth
                }
                for (index, segment) in self.segments.enumerate() {
                    segment.segmentFrame = self.segmentFrame(index)
                    segment.segmentFrame.origin.x += self.separatorWidth / 2
                }
            }
        } else {
            self.scrollView.contentInset = UIEdgeInsetsZero
        }
        
        // Add Content Layer
        for (index, segment) in self.segments.enumerate() {
            let content_x = segment.segmentFrame.origin.x + (segment.segmentFrame.width - segment.contentSize.width) / 2
            let content_y = (self.scrollView.frame.height - segment.contentSize.height) / 2
            let content_frame = CGRectMake(content_x, content_y, segment.contentSize.width, segment.contentSize.height)
            
            // Add Decoration Layer
            switch self.indicatorStyle {
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
            switch segment.type {
            case let .Text(text):
                let layerText = CATextLayer()
                layerText.string = text
                let font = UIFont.boldSystemFontOfSize(self.segmentTextFontSize)
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
        let addLayerSeparator = { [unowned self] in
            let layerSeparator = CALayer()
            layerSeparator.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)
            layerSeparator.backgroundColor = self.separatorColor.CGColor
            
            let layerMask = CAShapeLayer()
            layerMask.fillColor = UIColor.whiteColor().CGColor
            let maskPath = UIBezierPath()
            for (index, segment) in self.segments.enumerate() {
                index < self.segments.count - 1 ? maskPath.appendPath(UIBezierPath(rect: CGRectMake(CGRectGetMaxX(segment.segmentFrame) + self.separatorEdgeInsets.left, self.separatorEdgeInsets.top, self.separatorWidth - self.separatorEdgeInsets.left - self.separatorEdgeInsets.right, self.scrollView.frame.height - self.separatorEdgeInsets.top - self.separatorEdgeInsets.bottom))) : ()
            }
            layerMask.path = maskPath.CGPath
            layerSeparator.mask = layerMask
            self.scrollView.layer.addSublayer(layerSeparator)
        }
        let addLayerCover = { [unowned self] in
            let layerCover = CALayer()
            layerCover.frame = self.indicatorCoverFrame(self.selectedIndex)
            layerCover.backgroundColor = self.cover_color.CGColor
            layerCover.opacity = self.cover_opacity
            self.scrollView.layer.addSublayer(layerCover)
            self.layerCover = layerCover
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
        let addLayerStrip = { [unowned self] (stripFrame: CGRect, stripColor: UIColor) in
            let layerStrip = CALayer()
            layerStrip.frame = stripFrame
            layerStrip.backgroundColor = stripColor.CGColor
            self.scrollView.layer.addSublayer(layerStrip)
            self.layerStrip = layerStrip
        }
        let addLayerArrow = { [unowned self] (arrowFrame: CGRect, arrowLocation: IndicatorLocation, arrowColor: UIColor) in
            let layerArrow = CALayer()
            layerArrow.frame = arrowFrame
            layerArrow.backgroundColor = arrowColor.CGColor
            
            let layerMask = CAShapeLayer()
            layerMask.fillColor = UIColor.whiteColor().CGColor
            let maskPath = UIBezierPath()
            var pointA = CGPointZero
            var pointB = CGPointZero
            var pointC = CGPointZero
            switch arrowLocation {
            case .Up:
                pointA = CGPointMake(0, 0)
                pointB = CGPointMake(layerArrow.bounds.width, 0)
                pointC = CGPointMake(layerArrow.bounds.width / 2, layerArrow.bounds.height)
            case .Down:
                pointA = CGPointMake(0, layerArrow.bounds.height)
                pointB = CGPointMake(layerArrow.bounds.width, layerArrow.bounds.height)
                pointC = CGPointMake(layerArrow.bounds.width / 2, 0)
            }
            maskPath.moveToPoint(pointA)
            maskPath.addLineToPoint(pointB)
            maskPath.addLineToPoint(pointC)
            maskPath.closePath()
            layerMask.path = maskPath.CGPath
            layerArrow.mask = layerMask
            
            self.scrollView.layer.addSublayer(layerArrow)
            self.layerArrow = layerArrow
        }
        switch self.indicatorStyle {
        case .Cover:
            addLayerCover()
            self.enableSeparator ? addLayerSeparator() : ()
        case .Strip:
            let strip_frame = self.indicatorStripFrame(self.selectedIndex, stripHeight: self.strip_height, stripLocation: self.strip_location, stripRange: self.strip_range)
            self.enableSlideway ? addLayerSlideway(CGRectGetMidY(strip_frame), self.slidewayHeight, self.slidewayColor) : ()
            addLayerStrip(strip_frame, self.strip_color)
            self.enableSeparator ? addLayerSeparator() : ()
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
            addLayerArrow(arrow_frame, self.arrow_location, self.arrow_color)
            self.enableSeparator ? addLayerSeparator() : ()
        case .ArrowStrip:
            let strip_frame = self.indicatorStripFrame(self.selectedIndex, stripHeight: self.arrowStrip_stripHeight, stripLocation: self.arrowStrip_location, stripRange: self.arrowStrip_stripRange)
            self.enableSlideway ? addLayerSlideway(CGRectGetMidY(strip_frame), self.slidewayHeight, self.slidewayColor) : ()
            addLayerStrip(strip_frame, self.arrowStrip_color)
            let arrow_frame = self.indicatorArrowFrame(self.selectedIndex, arrowLocation: self.arrowStrip_location, arrowSize: self.arrowStrip_arrowSize)
            addLayerArrow(arrow_frame, self.arrowStrip_location, self.arrowStrip_color)
            self.enableSeparator ? addLayerSeparator() : ()
        }
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            self.selectedIndex = self.indexForTouch(touch.locationInView(self))
        }
    }
    
    // MARK: Custom methods
    func selectedIndexChanged(newIndex: Int, oldIndex: Int) {
        if self.enableAnimation {
            CATransaction.begin()
            CATransaction.setAnimationDuration(self.animationDuration)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
            CATransaction.setCompletionBlock({ [unowned self] in
                switch self.indicatorStyle {
                case .Rainbow:
                    self.switchRoundCornerForLayer(self.segments[oldIndex].layerStrip!, isRoundCorner: false)
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
        self.delegate?.segmentControl(self, didSelectIndex: selectedIndex)
    }
    
    func didSelectedIndexChanged(newIndex: Int, oldIndex: Int) {
        switch indicatorStyle {
        case .Cover:
            self.layerCover.actions = nil
            self.layerCover.frame = self.indicatorCoverFrame(newIndex)
        case .Strip:
            self.layerStrip.actions = nil
            self.layerStrip.frame = self.indicatorStripFrame(newIndex, stripHeight: self.strip_height, stripLocation: self.strip_location, stripRange: self.strip_range)
        case .Rainbow:
            if let old_StripLayer = self.segments[oldIndex].layerStrip {
                let old_StripFrame = old_StripLayer.frame
                old_StripLayer.frame = CGRectMake(old_StripFrame.origin.x, self.scrollView.frame.height - self.strip_height, old_StripFrame.width, self.strip_height)
            }
            if let new_StripLayer = self.segments[newIndex].layerStrip {
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
        
        switch self.segments[oldIndex].type {
        case .Text:
            if let old_contentLayer = self.segments[oldIndex].layerText as? CATextLayer {
                old_contentLayer.foregroundColor = self.segmentTextForegroundColor.CGColor
            }
        default:
            break
        }
        switch self.segments[newIndex].type {
        case .Text:
            if let new_contentLayer = self.segments[newIndex].layerText as? CATextLayer {
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
        let segmentFrame = self.segments[index].segmentFrame
        let targetRect = CGRectMake(segmentFrame.origin.x - (self.scrollView.frame.width - segmentFrame.width) / 2, 0, self.scrollView.frame.width, self.scrollView.frame.height)
        self.scrollView.scrollRectToVisible(targetRect, animated: true)
    }
    
    func segmentContentSize(segment: Segment) -> CGSize {
        var size = CGSizeZero
        switch segment.type {
        case let .Text(text):
            size = (text as NSString).sizeWithAttributes([
                NSFontAttributeName: UIFont.systemFontOfSize(self.segmentTextFontSize)
                ])
            size.width += CGFloat((text as NSString).length)
        case let .Icon(icon):
            size = icon.size
        }
        return CGSizeMake(ceil(size.width), ceil(size.height))
    }
    
    func segmentFrame(index: Int) -> CGRect {
        var segmentOffset: CGFloat = (self.enableSeparator && self.indicatorStyle != .Rainbow ? self.separatorWidth / 2 : 0)
        for (idx, segment) in self.segments.enumerate() {
            if idx == index {
                break
            } else {
                segmentOffset += segment.segmentWidth + (self.enableSeparator && self.indicatorStyle != .Rainbow ? self.separatorWidth : 0)
            }
        }
        return CGRectMake(segmentOffset , 0, self.segments[index].segmentWidth, self.scrollView.frame.height)
    }
    
    func indicatorCoverFrame(index: Int) -> CGRect {
        var box_x: CGFloat = self.segments[index].segmentFrame.origin.x
        var box_width: CGFloat = 0
        switch self.cover_range {
        case .Content:
            box_x += (self.segments[index].segmentWidth - self.segments[index].contentSize.width) / 2
            box_width = self.segments[index].contentSize.width
        case .Segment:
            box_width = self.segments[index].segmentWidth
        }
        return CGRectMake(box_x, 0, box_width, self.scrollView.frame.height)
    }
    
    func indicatorStripFrame(index: Int, stripHeight: CGFloat, stripLocation: IndicatorLocation, stripRange: IndicatorRange) -> CGRect {
        var strip_x: CGFloat = self.segments[index].segmentFrame.origin.x
        var strip_y: CGFloat = 0
        var strip_width: CGFloat = 0
        switch stripLocation {
        case .Down:
            strip_y = self.segments[index].segmentFrame.height - stripHeight
        case .Up:
            strip_y = 0
        }
        switch stripRange {
        case .Content:
            strip_width = self.segments[index].contentSize.width
            strip_x += (self.segments[index].segmentWidth - strip_width) / 2
        case .Segment:
            strip_width = self.segments[index].segmentWidth
        }
        return CGRectMake(strip_x, strip_y, strip_width, stripHeight)
    }
    
    func indicatorArrowFrame(index: Int, arrowLocation: IndicatorLocation, arrowSize: CGSize) -> CGRect {
        let arrow_x: CGFloat = self.segments[index].segmentFrame.origin.x + (self.segments[index].segmentFrame.width - arrowSize.width) / 2
        var arrow_y: CGFloat = 0
        switch arrowLocation {
        case .Up:
            arrow_y = 0
        case .Down:
            arrow_y = self.segments[index].segmentFrame.height - self.arrow_size.height
        }
        return CGRectMake(arrow_x, arrow_y, arrowSize.width, arrowSize.height)
    }
    
    func indexForTouch(location: CGPoint) -> Int {
        var touch_offset_x = location.x + self.scrollView.contentOffset.x
        var touch_index = 0
        for (index, segment) in self.segments.enumerate() {
            touch_offset_x -= segment.segmentWidth + (self.enableSeparator && self.indicatorStyle != .Rainbow ? self.separatorWidth : 0)
            if touch_offset_x < 0 {
                touch_index = index
                break
            }
        }
        return touch_index
    }
}

// MARK: Extension - Inner type defination
extension WBSegmentControl {
    
    // MARK: Segment
    public class Segment {
        
        public let type: SegmentType
        
        private var layerText: CALayer?
        private var layerIcon: CALayer?
        private var layerStrip: CALayer?
        
        private var segmentFrame: CGRect = CGRectZero
        private var segmentWidth: CGFloat = 0
        private var contentSize: CGSize = CGSizeZero
        
        public init(type: SegmentType) {
            self.type = type
        }
    }
    
    // MARK: SegmentType
    public enum SegmentType {
        case Text(String)
        case Icon(UIImage)
    }
    
    // MARK: IndicatorStyle
    public enum IndicatorStyle {
        case Cover, Strip, Rainbow, Arrow, ArrowStrip
    }
    
    // MARK: IndicatorLocation
    public enum IndicatorLocation {
        case Up, Down
    }
    
    // MARK: IndicatorRange
    public enum IndicatorRange {
        case Content, Segment
    }
    
    // MARK: DistributionStyle
    public enum NonScrollDistributionStyle {
        case Center, Left, Right, Average
    }
}

// MARK: Extension - UIScrollView
extension UIScrollView {
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.dragging == true {
            super.touchesBegan(touches, withEvent: event)
        } else {
            self.nextResponder()?.touchesBegan(touches, withEvent: event)
        }
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.dragging == true {
            super.touchesMoved(touches, withEvent: event)
        } else {
            self.nextResponder()?.touchesMoved(touches, withEvent: event)
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.dragging == true {
            super.touchesEnded(touches, withEvent: event)
        } else {
            self.nextResponder()?.touchesEnded(touches, withEvent: event)
        }
    }
}
