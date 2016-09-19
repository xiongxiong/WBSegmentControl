//
//  ViewController1.swift
//  WBSegmentControl
//
//  Created by 王继荣 on 7/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import WBSegmentControl

class ViewController1: UIViewController {
    
    var segmentControl: WBSegmentControl!
    var viewPages = UIView()
    var viewLabel = UILabel()
    var pagesController: UIPageViewController!
    var pages: [UIViewController] = []
    
    override func loadView() {
        super.loadView()
        
        initSegmentControl()
        initPagesController()
        
        view.addSubview(segmentControl)
        view.addSubview(viewPages)
        viewPages.addSubview(pagesController.view)
        view.addSubview(viewLabel)
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentControl]|", options: .alignAllLeading, metrics: nil, views: ["segmentControl": segmentControl]))
        view.addConstraint(NSLayoutConstraint(item: segmentControl, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: segmentControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 40))
        
        viewPages.gestureRecognizers = pagesController.gestureRecognizers
        viewPages.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewPages]|", options: .alignAllLeading, metrics: nil, views: ["viewPages": viewPages]))
        view.addConstraint(NSLayoutConstraint(item: viewPages, attribute: .top, relatedBy: .equal, toItem: segmentControl, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: viewPages, attribute: .bottom, relatedBy: .equal, toItem: viewLabel, attribute: .top, multiplier: 1, constant: 0))
        
        pagesController.view.translatesAutoresizingMaskIntoConstraints = false
        viewPages.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pagesView]|", options: .alignAllLeading, metrics: nil, views: ["pagesView": pagesController.view]))
        viewPages.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pagesView]|", options: .alignAllFirstBaseline, metrics: nil, views: ["pagesView": pagesController.view]))
        
        viewLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewLabel]|", options: .alignAllLeading, metrics: nil, views: ["viewLabel": viewLabel]))
        view.addConstraint(NSLayoutConstraint(item: viewLabel, attribute: .top, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: viewLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 40))
        
        viewLabel.textAlignment = .center
        viewLabel.textColor = UIColor.black
        viewLabel.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControl.selectedIndex = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSegmentControl() {
        segmentControl = WBSegmentControl()
        segmentControl.segments = [
            TextSegment(text: "News China", otherAttr: "News China"),
            TextSegment(text: "Breaking News", otherAttr: "Breaking News"),
            TextSegment(text: "World", otherAttr: "World"),
            TextSegment(text: "Science", otherAttr: "Science"),
            TextSegment(text: "Entertainment & Arts", otherAttr: "Entertainment & Arts"),
            TextSegment(text: "Finance", otherAttr: "Finance"),
            TextSegment(text: "Video", otherAttr: "Video"),
            TextSegment(text: "Radio", otherAttr: "Radio"),
            TextSegment(text: "Education", otherAttr: "Education"),
            TextSegment(text: "Sports", otherAttr: "Sports"),
            TextSegment(text: "Weather", otherAttr: "Weather"),
            TextSegment(text: "Headlines", otherAttr: "Headlines"),
        ]
        segmentControl.style = .rainbow
        segmentControl.segmentTextBold = false
        segmentControl.rainbow_colors = [
            UIColor(red:0.91, green:0.18, blue:0.24, alpha:1.00),
            UIColor(red:1.00, green:0.71, blue:0.26, alpha:1.00),
            UIColor(red:0.47, green:0.78, blue:0.97, alpha:1.00)
        ]
        segmentControl.delegate = self
    }
    
    func initPagesController() {
        pagesController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pagesController.dataSource = self
        pagesController.delegate = self
        
        segmentControl.segments.enumerated().forEach { (index, _) in
            let vc = UIViewController()
            vc.view.backgroundColor = [
                UIColor(red:0.91, green:0.18, blue:0.24, alpha:1.00),
                UIColor(red:1.00, green:0.71, blue:0.26, alpha:1.00),
                UIColor(red:0.47, green:0.78, blue:0.97, alpha:1.00)
                ][index % 3]
            pages.append(vc)
        }
    }
    
}

extension ViewController1: WBSegmentControlDelegate {
    func segmentControl(_ segmentControl: WBSegmentControl, selectIndex newIndex: Int, oldIndex: Int) {
        let targetPages = [pages[newIndex]]
        let direction = ((newIndex > oldIndex) ? UIPageViewControllerNavigationDirection.forward : UIPageViewControllerNavigationDirection.reverse)
        pagesController.setViewControllers(targetPages, direction: direction, animated: true, completion: nil)
        
        if let selectedSegment = segmentControl.selectedSegment as? TextSegment {
            viewLabel.text = selectedSegment.otherAttr
        }
    }
}

extension ViewController1: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = pages.index(of: viewController)!
        return index > 0 ? pages[index - 1] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = pages.index(of: viewController)!
        return index < pages.count - 1 ? pages[index + 1] : nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension ViewController1: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed == false {
            guard let targetPage = previousViewControllers.first else {
                return
            }
            guard let targetIndex = pages.index(of: targetPage) else {
                return
            }
            segmentControl.selectedIndex = targetIndex
            pageViewController.setViewControllers(previousViewControllers, direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let targetPage = pendingViewControllers.first else {
            return
        }
        guard let targetIndex = pages.index(of: targetPage) else {
            return
        }
        segmentControl.selectedIndex = targetIndex
    }
}
