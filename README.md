# WBSegmentControl

[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![CI Status](http://img.shields.io/travis/xiongxiong/WBSegmentControl.svg?style=flat)](https://travis-ci.org/xiongxiong/WBSegmentControl)
[![Version](https://img.shields.io/cocoapods/v/WBSegmentControl.svg?style=flat)](http://cocoapods.org/pods/WBSegmentControl)
[![Platform](https://img.shields.io/cocoapods/p/WBSegmentControl.svg?style=flat)](http://cocoapods.org/pods/WBSegmentControl)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/WBSegmentControl.svg?style=flat)](http://cocoapods.org/pods/WBSegmentControl)

An easy to use, customizable segment control, can be used to show tabs.

![WBSegmentControl](Framework/ScreenShot/WBSegmentControl.gif "WBSegmentControl")

## Contents
- [Features](#features)
- [Requirements](#requirements)
- [Example](#example)
- [Installation](#installation)
- [Protocols](#protocols)
- [Usage](#usage)
- [Properties](#properties)
- [Author](#author)
- [License](#license)

## Features
- [x] Flexible style - rainbow | cover | strip | arrow | arrowStrip
- [x] Action delegate support
- [x] Customized segment

## Requirements

- iOS 8.0+ / Mac OS X 10.11+ / tvOS 9.0+
- Xcode 8.0+
- Swift 3.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```
To integrate WBSegmentControl into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'WBSegmentControl', '~> 0.2.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate WBSegmentControl into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "xiongxiong/WBSegmentControl" ~> 0.2.0
```

Run `carthage update` to build the framework and drag the built `WBSegmentControl.framework` into your Xcode project.

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate WBSegmentControl into your project manually.

## Example

Open the example project, build and run.

## Protocols

### WBSegmentControlDelegate

```swift
public protocol WBSegmentControlDelegate {
    func segmentControl(segmentControl: WBSegmentControl, selectIndex newIndex: Int, oldIndex: Int)
}
```

### WBSegmentProtocol

```swift
public protocol WBSegmentContentProtocol {
    var type: WBSegmentType { get }
}
```

## Usage

### Implement WBSegmentContentProtocol

```swift
class TextSegment: NSObject, WBSegmentContentProtocol {

    var text: String!

    var type: WBSegmentType {
        return WBSegmentType.Text(text)
    }

    init(text: String) {
        super.init()

        self.text = text
    }
}
```

IconSegment & TextSegment are already implemented, you can use it straightforwardly without implementing WBSegmentContentProtocol, or you can choose to implement WBSegmentContentProtocol to use your own segment type.

### Initialize segmentControl

```swift
let segmentControl = WBSegmentControl() // initialize
view.addSubview(segmentControl)
...
segmentControl.segments = [
    TextSegment(text: "News China"),
    TextSegment(text: "Breaking News"),
] // set segments
segmentControl.style = .Rainbow // set style
segmentControl.selectedIndex = 0 // set selected index
```

### Implement WBSegmentControlDelegate

```swift
extension MyViewController: WBSegmentControlDelegate {
    func segmentControl(segmentControl: WBSegmentControl, selectIndex newIndex: Int, oldIndex: Int) {

    }
}
```

### Get selected segment

```swift
let selectedIndex = segmentControl.selectedIndex
let selectedSegment: TextSegment? = segmentControl.selectedSegment as? TextSegment
```

## Properties

### Settings - Common

* indicatorStyle: IndicatorStyle = rainbow | cover | strip | arrow | arrowStrip
* nonScrollDistributionStyle: NonScrollDistributionStyle = center | left | right | average
* enableSeparator: Bool
* separatorColor: UIColor
* separatorWidth: CGFloat
* separatorEdgeInsets: UIEdgeInsets
* enableSlideway: Bool
* slidewayHeight: CGFloat
* slidewayColor: UIColor
* enableAnimation: Bool
* animationDuration: NSTimeInterval
* contentBackgroundColor: UIColor
* segmentMinWidth: CGFloat
* segmentEdgeInsets: UIEdgeInsets
* segmentTextBold: Bool
* segmentTextFontSize: CGFloat
* segmentTextForegroundColor: UIColor
* segmentTextForegroundColorSelected: UIColor

### Settings - indicatorStyle == .Rainbow

* rainbow_colors: [UIColor]
* rainbow_height: CGFloat
* rainbow_roundCornerRadius: CGFloat
* rainbow_location: RainbowLocation = up | down
* rainbow_outsideColor: UIColor

### Settings - indicatorStyle == .Cover

* cover_range: CoverRange = segment | content
* cover_opacity: Float
* cover_color: UIColor

### Settings - indicatorStyle == .Strip

* strip_range: StripRange = segment | content
* strip_location: StripLocation = up | down
* strip_color: UIColor
* strip_height: CGFloat

### Settings - indicatorStyle == .Rainbow
    public var rainbow_colors: [UIColor] = []
    public var rainbow_height: CGFloat = 3
    public var rainbow_roundCornerRadius: CGFloat = 4
    public var rainbow_location: RainbowLocation = .Down
    public var rainbow_outsideColor: UIColor = UIColor.grayColor()

### Settings - indicatorStyle == .Arrow

* arrow_size: CGSize
* arrow_location: ArrowLocation = up | down
* arrow_color: UIColor

### Settings - indicatorStyle == .ArrowStrip

* arrowStrip_location: ArrowStripLocation = up | down
* arrowStrip_color: UIColor
* arrowStrip_arrowSize: CGSize
* arrowStrip_stripHeight: CGFloat
* arrowStrip_stripRange: ArrowStripRange = segment | content

## Author

xiongxiong, ximengwuheng@163.com

## License

WBSegmentControl is available under the MIT license. See the LICENSE file for more info.
