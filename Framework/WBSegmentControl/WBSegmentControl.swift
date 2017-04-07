//
//  CustomSegmentControl2.swift
//  TrafficSecretary
//
//  Created by 王继荣 on 4/9/16.
//  Copyright © 2016 wonderbear. All rights reserved.
//

import UIKit

public protocol WBSegmentControlDelegate {
    func segmentControl(_ segmentControl: WBSegmentControl, selectIndex newIndex: Int, oldIndex: Int)
}

public protocol WBSegmentContentProtocol {
    var type: WBSegmentType { get }
}

public protocol WBTouchViewDelegate {
    func didTouch(_ location: CGPoint)
}

public class WBSegmentControl: UIControl {

    // MARK: Configuration - Content
    public var segments: [WBSegmentContentProtocol] = [] {
        didSet {
            innerSegments = segments.map({ (content) -> WBInnerSegment in
                return WBInnerSegment(content: content)
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
    public var style: WBSegmentIndicatorStyle = .rainbow
    public var nonScrollDistributionStyle: WBSegmentNonScrollDistributionStyle = .average
    public var enableSeparator: Bool = false
    public var separatorColor: UIColor = UIColor.black
    public var separatorWidth: CGFloat = 9
    public var separatorEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
    public var enableSlideway: Bool = false
    public var slidewayHeight: CGFloat = 1
    public var slidewayColor: UIColor = UIColor.lightGray
    public var enableAnimation: Bool = true
    public var animationDuration: TimeInterval = 0.15
    public var segmentMinWidth: CGFloat = 50
    public var segmentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    public var segmentTextBold: Bool = true
    public var segmentTextFontSize: CGFloat = 12
    public var segmentForegroundColor: UIColor = UIColor.gray
    public var segmentForegroundColorSelected: UIColor = UIColor.black

    // Settings - Cover
    public typealias CoverRange = WBSegmentIndicatorRange

    public var cover_range: CoverRange = .segment
    public var cover_opacity: Float = 0.2
    public var cover_color: UIColor = UIColor.black

    // Settings - Strip
    public typealias StripRange = WBSegmentIndicatorRange
    public typealias StripLocation = WBSegmentIndicatorLocation

    public var strip_range: StripRange = .content
    public var strip_location: StripLocation = .down
    public var strip_color: UIColor = UIColor.orange
    public var strip_height: CGFloat = 3

    // Settings - Rainbow
    public typealias RainbowLocation = WBSegmentIndicatorLocation

    public var rainbow_colors: [UIColor] = []
    public var rainbow_height: CGFloat = 3
    public var rainbow_roundCornerRadius: CGFloat = 4
    public var rainbow_location: RainbowLocation = .down
    public var rainbow_outsideColor: UIColor = UIColor.gray

    // Settings - Arrow
    public typealias ArrowLocation = WBSegmentIndicatorLocation

    public var arrow_size: CGSize = CGSize(width: 6, height: 6)
    public var arrow_location: ArrowLocation = .down
    public var arrow_color: UIColor = UIColor.orange

    // Settings - ArrowStrip
    public typealias ArrowStripLocation = WBSegmentIndicatorLocation
    public typealias ArrowStripRange = WBSegmentIndicatorRange

    public var arrowStrip_location: ArrowStripLocation = .up
    public var arrowStrip_color: UIColor = UIColor.orange
    public var arrowStrip_arrowSize: CGSize = CGSize(width: 6, height: 6)
    public var arrowStrip_stripHeight: CGFloat = 2
    public var arrowStrip_stripRange: ArrowStripRange = .content

    // MARK: Inner properties
    fileprivate var scrollView: UIScrollView!
    fileprivate var touchView: WBTouchView = WBTouchView()
    fileprivate var layerContainer: CALayer = CALayer()
    fileprivate var layerCover: CALayer = CALayer()
    fileprivate var layerStrip: CALayer = CALayer()
    fileprivate var layerArrow: CALayer = CALayer()
    fileprivate var segmentControlContentWidth: CGFloat {
        let sum = self.innerSegments.reduce(0, { (max_x, segment) -> CGFloat in
            return max(max_x, segment.segmentFrame.maxX)
        })
        return sum + ((self.enableSeparator && self.style != .rainbow) ? self.separatorWidth / 2 : 0)
    }

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        scrollView = UIScrollView()
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.layer.addSublayer(layerContainer)

        scrollView.addSubview(touchView)
        touchView.delegate = self
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Override methods
    override public func layoutSubviews() {
        super.layoutSubviews()
        layerContainer.sublayers?.removeAll()

        // Compute Segment Size
        for (index, segment) in self.innerSegments.enumerated() {
            segment.contentSize = self.segmentContentSize(segment)
            segment.segmentWidth = max(segment.contentSize.width + self.segmentEdgeInsets.left + self.segmentEdgeInsets.right, self.segmentMinWidth)
            segment.segmentFrame = self.segmentFrame(index)
        }

        // Adjust Control Content Size & Segment Size
        self.scrollView.contentSize = CGSize(width: self.segmentControlContentWidth, height: self.scrollView.frame.height)
        if self.scrollView.contentSize.width < self.scrollView.frame.width {
            switch self.nonScrollDistributionStyle {
            case .center:
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: (self.scrollView.frame.width - self.scrollView.contentSize.width) / 2, bottom: 0, right: 0)
            case .left:
                self.scrollView.contentInset = UIEdgeInsets.zero
            case .right:
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: self.scrollView.frame.width - self.scrollView.contentSize.width, bottom: 0, right: 0)
            case .average:
                self.scrollView.contentInset = UIEdgeInsets.zero
                self.scrollView.contentSize = self.scrollView.frame.size
                var averageWidth: CGFloat = (self.scrollView.frame.width - (self.enableSeparator && self.style != .rainbow ? CGFloat(self.innerSegments.count) * self.separatorWidth : 0)) / CGFloat(self.innerSegments.count)
                let largeSegments = self.innerSegments.filter({ (segment) -> Bool in
                    return segment.segmentWidth >= averageWidth
                })
                let smallSegments = self.innerSegments.filter({ (segment) -> Bool in
                    return segment.segmentWidth < averageWidth
                })
                let sumLarge = largeSegments.reduce(0, { (total, segment) -> CGFloat in
                    return total + segment.segmentWidth
                })
                averageWidth = (self.scrollView.frame.width - (self.enableSeparator && self.style != .rainbow ? CGFloat(self.innerSegments.count) * self.separatorWidth : 0) - sumLarge) / CGFloat(smallSegments.count)
                for segment in smallSegments {
                    segment.segmentWidth = averageWidth
                }
                for (index, segment) in self.innerSegments.enumerated() {
                    segment.segmentFrame = self.segmentFrame(index)
                    segment.segmentFrame.origin.x += self.separatorWidth / 2
                }
            }
        } else {
            self.scrollView.contentInset = UIEdgeInsets.zero
        }

        // Add Touch View
        touchView.frame = CGRect(origin: CGPoint.zero, size: self.scrollView.contentSize)

        // Add Segment SubLayers
        for (index, segment) in self.innerSegments.enumerated() {
            let content_x = segment.segmentFrame.origin.x + (segment.segmentFrame.width - segment.contentSize.width) / 2
            let content_y = (self.scrollView.frame.height - segment.contentSize.height) / 2
            let content_frame = CGRect(x: content_x, y: content_y, width: segment.contentSize.width, height: segment.contentSize.height)

            // Add Decoration Layer
            switch self.style {
            case .rainbow:
                let layerStrip = CALayer()
                layerStrip.frame = CGRect(x: segment.segmentFrame.origin.x, y: index == self.selectedIndex ? 0 : segment.segmentFrame.height - self.rainbow_height, width: segment.segmentFrame.width, height: index == self.selectedIndex ? self.scrollView.frame.height : self.rainbow_height)
                if self.rainbow_colors.isEmpty == false {
                    layerStrip.backgroundColor = self.rainbow_colors[index % self.rainbow_colors.count].cgColor
                }
                layerContainer.addSublayer(layerStrip)
                self.switchRoundCornerForLayer(layerStrip, isRoundCorner: index == self.selectedIndex)
                segment.layerStrip = layerStrip
            default:
                break
            }

            // Add Content Layer
            switch segment.content.type {
            case let .text(text):
                let layerText = CATextLayer()
                layerText.string = text
                let font = segmentTextBold ? UIFont.boldSystemFont(ofSize: self.segmentTextFontSize) : UIFont.systemFont(ofSize: self.segmentTextFontSize)
                layerText.font = CGFont(NSString(string:font.fontName))
                layerText.fontSize = font.pointSize
                layerText.frame = content_frame
                layerText.alignmentMode = kCAAlignmentCenter
                layerText.truncationMode = kCATruncationEnd
                layerText.contentsScale = UIScreen.main.scale
                layerText.foregroundColor = index == self.selectedIndex ? self.segmentForegroundColorSelected.cgColor : self.segmentForegroundColor.cgColor
                layerContainer.addSublayer(layerText)
                segment.layerText = layerText
            case let .icon(icon):
                let layerIcon = CALayer()
                let image = icon
                layerIcon.frame = content_frame
                layerIcon.contents = image.cgImage
                layerContainer.addSublayer(layerIcon)
                segment.layerIcon = layerIcon
            }
        }

        // Add Indicator Layer
        let initLayerSeparator = { [unowned self] in
            let layerSeparator = CALayer()
            layerSeparator.frame = CGRect(x: 0, y: 0, width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height)
            layerSeparator.backgroundColor = self.separatorColor.cgColor

            let layerMask = CAShapeLayer()
            layerMask.fillColor = UIColor.white.cgColor
            let maskPath = UIBezierPath()
            for (index, segment) in self.innerSegments.enumerated() {
                index < self.innerSegments.count - 1 ? maskPath.append(UIBezierPath(rect: CGRect(x: segment.segmentFrame.maxX + self.separatorEdgeInsets.left, y: self.separatorEdgeInsets.top, width: self.separatorWidth - self.separatorEdgeInsets.left - self.separatorEdgeInsets.right, height: self.scrollView.frame.height - self.separatorEdgeInsets.top - self.separatorEdgeInsets.bottom))) : ()
            }
            layerMask.path = maskPath.cgPath
            layerSeparator.mask = layerMask
            self.layerContainer.addSublayer(layerSeparator)
        }
        let initLayerCover = { [unowned self] in
            self.layerCover.frame = self.indicatorCoverFrame(self.selectedIndex)
            self.layerCover.backgroundColor = self.cover_color.cgColor
            self.layerCover.opacity = self.cover_opacity
            self.layerContainer.addSublayer(self.layerCover)
        }
        let addLayerOutside = { [unowned self] in
            let outsideLayerLeft = CALayer()
            outsideLayerLeft.frame = CGRect(x: -1 * self.scrollView.frame.width, y: self.scrollView.frame.height - self.rainbow_height, width: self.scrollView.frame.width, height: self.rainbow_height)
            outsideLayerLeft.backgroundColor = self.rainbow_outsideColor.cgColor
            self.layerContainer.addSublayer(outsideLayerLeft)

            let outsideLayerRight = CALayer()
            outsideLayerRight.frame = CGRect(x: self.scrollView.contentSize.width, y: self.scrollView.frame.height - self.rainbow_height, width: self.scrollView.frame.width, height: self.rainbow_height)
            outsideLayerRight.backgroundColor = self.rainbow_outsideColor.cgColor
            self.layerContainer.addSublayer(outsideLayerRight)
        }
        let addLayerSlideway = { [unowned self] (slidewayPosition: CGFloat, slidewayHeight: CGFloat, slidewayColor: UIColor) in
            let layerSlideway = CALayer()
            layerSlideway.frame = CGRect(x: -1 * self.scrollView.frame.width, y: slidewayPosition - slidewayHeight / 2, width: self.scrollView.contentSize.width + self.scrollView.frame.width * 2, height: slidewayHeight)
            layerSlideway.backgroundColor = slidewayColor.cgColor
            self.layerContainer.addSublayer(layerSlideway)
        }
        let initLayerStrip = { [unowned self] (stripFrame: CGRect, stripColor: UIColor) in
            self.layerStrip.frame = stripFrame
            self.layerStrip.backgroundColor = stripColor.cgColor
            self.layerContainer.addSublayer(self.layerStrip)
        }
        let initLayerArrow = { [unowned self] (arrowFrame: CGRect, arrowLocation: WBSegmentIndicatorLocation, arrowColor: UIColor) in
            self.layerArrow.frame = arrowFrame
            self.layerArrow.backgroundColor = arrowColor.cgColor

            let layerMask = CAShapeLayer()
            layerMask.fillColor = UIColor.white.cgColor
            let maskPath = UIBezierPath()
            var pointA = CGPoint.zero
            var pointB = CGPoint.zero
            var pointC = CGPoint.zero
            switch arrowLocation {
            case .up:
                pointA = CGPoint(x: 0, y: 0)
                pointB = CGPoint(x: self.layerArrow.bounds.width, y: 0)
                pointC = CGPoint(x: self.layerArrow.bounds.width / 2, y: self.layerArrow.bounds.height)
            case .down:
                pointA = CGPoint(x: 0, y: self.layerArrow.bounds.height)
                pointB = CGPoint(x: self.layerArrow.bounds.width, y: self.layerArrow.bounds.height)
                pointC = CGPoint(x: self.layerArrow.bounds.width / 2, y: 0)
            }
            maskPath.move(to: pointA)
            maskPath.addLine(to: pointB)
            maskPath.addLine(to: pointC)
            maskPath.close()
            layerMask.path = maskPath.cgPath
            self.layerArrow.mask = layerMask

            self.layerContainer.addSublayer(self.layerArrow)
        }
        switch self.style {
        case .cover:
            initLayerCover()
            self.enableSeparator ? initLayerSeparator() : ()
        case .strip:
            let strip_frame = self.indicatorStripFrame(self.selectedIndex, stripHeight: self.strip_height, stripLocation: self.strip_location, stripRange: self.strip_range)
            self.enableSlideway ? addLayerSlideway(strip_frame.midY, self.slidewayHeight, self.slidewayColor) : ()
            initLayerStrip(strip_frame, self.strip_color)
            self.enableSeparator ? initLayerSeparator() : ()
        case .rainbow:
            addLayerOutside()
        case .arrow:
            let arrow_frame = self.indicatorArrowFrame(self.selectedIndex, arrowLocation: self.arrow_location, arrowSize: self.arrow_size)
            var slideway_y: CGFloat = 0
            switch self.arrow_location {
            case .up:
                slideway_y = arrow_frame.origin.y + self.slidewayHeight / 2
            case .down:
                slideway_y = arrow_frame.maxY - self.slidewayHeight / 2
            }
            self.enableSlideway ? addLayerSlideway(slideway_y, self.slidewayHeight, self.slidewayColor) : ()
            initLayerArrow(arrow_frame, self.arrow_location, self.arrow_color)
            self.enableSeparator ? initLayerSeparator() : ()
        case .arrowStrip:
            let strip_frame = self.indicatorStripFrame(self.selectedIndex, stripHeight: self.arrowStrip_stripHeight, stripLocation: self.arrowStrip_location, stripRange: self.arrowStrip_stripRange)
            self.enableSlideway ? addLayerSlideway(strip_frame.midY, self.slidewayHeight, self.slidewayColor) : ()
            initLayerStrip(strip_frame, self.arrowStrip_color)
            let arrow_frame = self.indicatorArrowFrame(self.selectedIndex, arrowLocation: self.arrowStrip_location, arrowSize: self.arrowStrip_arrowSize)
            initLayerArrow(arrow_frame, self.arrowStrip_location, self.arrowStrip_color)
            self.enableSeparator ? initLayerSeparator() : ()
        }
    }

    // MARK: Custom methods
    func selectedIndexChanged(_ newIndex: Int, oldIndex: Int) {
        if self.enableAnimation && validIndex(oldIndex) {
            CATransaction.begin()
            CATransaction.setAnimationDuration(self.animationDuration)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
            CATransaction.setCompletionBlock({ [unowned self] in
                switch self.style {
                case .rainbow:
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

        self.sendActions(for: .valueChanged)
    }

    func didSelectedIndexChanged(_ newIndex: Int, oldIndex: Int) {
        switch style {
        case .cover:
            self.layerCover.actions = nil
            self.layerCover.frame = self.indicatorCoverFrame(newIndex)
        case .strip:
            self.layerStrip.actions = nil
            self.layerStrip.frame = self.indicatorStripFrame(newIndex, stripHeight: self.strip_height, stripLocation: self.strip_location, stripRange: self.strip_range)
        case .rainbow:
            if validIndex(oldIndex), let old_StripLayer = self.innerSegments[oldIndex].layerStrip {
                let old_StripFrame = old_StripLayer.frame
                old_StripLayer.frame = CGRect(x: old_StripFrame.origin.x, y: self.scrollView.frame.height - self.strip_height, width: old_StripFrame.width, height: self.strip_height)
            }
            if let new_StripLayer = self.innerSegments[newIndex].layerStrip {
                let new_StripFrame = new_StripLayer.frame
                new_StripLayer.frame = CGRect(x: new_StripFrame.origin.x, y: 0, width: new_StripFrame.width, height: self.scrollView.frame.height)
                self.switchRoundCornerForLayer(new_StripLayer, isRoundCorner: true)
            }
        case .arrow:
            self.layerArrow.actions = nil
            self.layerArrow.frame = self.indicatorArrowFrame(newIndex, arrowLocation: self.arrow_location, arrowSize: self.arrow_size)
        case .arrowStrip:
            self.layerStrip.actions = nil
            self.layerStrip.frame = self.indicatorStripFrame(newIndex, stripHeight: self.arrowStrip_stripHeight, stripLocation: self.arrowStrip_location, stripRange: self.arrowStrip_stripRange)
            self.layerArrow.actions = nil
            self.layerArrow.frame = self.indicatorArrowFrame(newIndex, arrowLocation: self.arrowStrip_location, arrowSize: self.arrowStrip_arrowSize)
        }

        if validIndex(oldIndex) {
            switch self.innerSegments[oldIndex].content.type {
            case .text:
                if let old_contentLayer = self.innerSegments[oldIndex].layerText as? CATextLayer {
                    old_contentLayer.foregroundColor = self.segmentForegroundColor.cgColor
                }
            default:
                break
            }
        }
        switch self.innerSegments[newIndex].content.type {
        case .text:
            if let new_contentLayer = self.innerSegments[newIndex].layerText as? CATextLayer {
                new_contentLayer.foregroundColor = self.segmentForegroundColorSelected.cgColor
            }
        default:
            break
        }
    }

    func switchRoundCornerForLayer(_ layer: CALayer, isRoundCorner: Bool) {
        if isRoundCorner {
            let layerMask = CAShapeLayer()
            layerMask.fillColor = UIColor.white.cgColor
            layerMask.path = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: layer.frame.size), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: self.rainbow_roundCornerRadius, height: self.rainbow_roundCornerRadius)).cgPath
            layer.mask = layerMask
        } else {
            layer.mask = nil
        }
    }

    func scrollToSegment(_ index: Int) {
        let segmentFrame = self.innerSegments[index].segmentFrame
        let targetRect = CGRect(x: segmentFrame.origin.x - (self.scrollView.frame.width - segmentFrame.width) / 2, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        self.scrollView.scrollRectToVisible(targetRect, animated: true)
    }

    func segmentContentSize(_ segment: WBInnerSegment) -> CGSize {
        var size = CGSize.zero
        switch segment.content.type {
        case let .text(text):
            size = (text as NSString).size(attributes: [
                NSFontAttributeName: segmentTextBold ? UIFont.boldSystemFont(ofSize: self.segmentTextFontSize) : UIFont.systemFont(ofSize: self.segmentTextFontSize)
                ])
        case let .icon(icon):
            size = icon.size
        }
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }

    func segmentFrame(_ index: Int) -> CGRect {
        var segmentOffset: CGFloat = (self.enableSeparator && self.style != .rainbow ? self.separatorWidth / 2 : 0)
        for (idx, segment) in self.innerSegments.enumerated() {
            if idx == index {
                break
            } else {
                segmentOffset += segment.segmentWidth + (self.enableSeparator && self.style != .rainbow ? self.separatorWidth : 0)
            }
        }
        return CGRect(x: segmentOffset , y: 0, width: self.innerSegments[index].segmentWidth, height: self.scrollView.frame.height)
    }

    func indicatorCoverFrame(_ index: Int) -> CGRect {
        if validIndex(index) {
            var box_x: CGFloat = self.innerSegments[index].segmentFrame.origin.x
            var box_width: CGFloat = 0
            switch self.cover_range {
            case .content:
                box_x += (self.innerSegments[index].segmentWidth - self.innerSegments[index].contentSize.width) / 2
                box_width = self.innerSegments[index].contentSize.width
            case .segment:
                box_width = self.innerSegments[index].segmentWidth
            }
            return CGRect(x: box_x, y: 0, width: box_width, height: self.scrollView.frame.height)
        } else {
            return CGRect.zero
        }
    }

    func indicatorStripFrame(_ index: Int, stripHeight: CGFloat, stripLocation: WBSegmentIndicatorLocation, stripRange: WBSegmentIndicatorRange) -> CGRect {
        if validIndex(index) {
            var strip_x: CGFloat = self.innerSegments[index].segmentFrame.origin.x
            var strip_y: CGFloat = 0
            var strip_width: CGFloat = 0
            switch stripLocation {
            case .down:
                strip_y = self.innerSegments[index].segmentFrame.height - stripHeight
            case .up:
                strip_y = 0
            }
            switch stripRange {
            case .content:
                strip_width = self.innerSegments[index].contentSize.width
                strip_x += (self.innerSegments[index].segmentWidth - strip_width) / 2
            case .segment:
                strip_width = self.innerSegments[index].segmentWidth
            }
            return CGRect(x: strip_x, y: strip_y, width: strip_width, height: stripHeight)
        } else {
            return CGRect.zero
        }
    }

    func indicatorArrowFrame(_ index: Int, arrowLocation: WBSegmentIndicatorLocation, arrowSize: CGSize) -> CGRect {
        if validIndex(index) {
            let arrow_x: CGFloat = self.innerSegments[index].segmentFrame.origin.x + (self.innerSegments[index].segmentFrame.width - arrowSize.width) / 2
            var arrow_y: CGFloat = 0
            switch arrowLocation {
            case .up:
                arrow_y = 0
            case .down:
                arrow_y = self.innerSegments[index].segmentFrame.height - self.arrow_size.height
            }
            return CGRect(x: arrow_x, y: arrow_y, width: arrowSize.width, height: arrowSize.height)
        } else {
            return CGRect.zero
        }
    }

    func indexForTouch(_ location: CGPoint) -> Int {
        var touch_offset_x = location.x
        var touch_index = 0
        for (index, segment) in self.innerSegments.enumerated() {
            touch_offset_x -= segment.segmentWidth + (self.enableSeparator && self.style != .rainbow ? self.separatorWidth : 0)
            if touch_offset_x < 0 {
                touch_index = index
                break
            }
        }
        return touch_index
    }

    func validIndex(_ index: Int) -> Bool {
        return index >= 0 && index < segments.count
    }
}

extension WBSegmentControl: WBTouchViewDelegate {
    public func didTouch(_ location: CGPoint) {
        selectedIndex = indexForTouch(location)
    }
}

class WBInnerSegment {

    let content: WBSegmentContentProtocol

    var segmentFrame: CGRect = CGRect.zero
    var segmentWidth: CGFloat = 0
    var contentSize: CGSize = CGSize.zero

    var layerText: CALayer!
    var layerIcon: CALayer!
    var layerStrip: CALayer!

    init(content: WBSegmentContentProtocol) {
        self.content = content
    }
}

public enum WBSegmentType {
    case text(String)
    case icon(UIImage)
}

public enum WBSegmentIndicatorStyle {
    case cover, strip, rainbow, arrow, arrowStrip
}

public enum WBSegmentIndicatorLocation {
    case up, down
}

public enum WBSegmentIndicatorRange {
    case content, segment
}

public enum WBSegmentNonScrollDistributionStyle {
    case center, left, right, average
}

class WBTouchView: UIView {

    var delegate: WBTouchViewDelegate?

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            delegate?.didTouch(touch.location(in: self))
        }
    }
}
