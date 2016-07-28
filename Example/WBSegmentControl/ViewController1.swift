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
        
        segmentControl.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_topLayoutGuideBottom)
            make.height.equalTo(40)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
        
        viewPages.gestureRecognizers = pagesController.gestureRecognizers
        viewPages.snp_makeConstraints { (make) in
            make.top.equalTo(segmentControl.snp_bottom)
            make.bottom.equalTo(viewLabel)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
        
        pagesController.view.snp_makeConstraints { (make) in
            make.edges.equalTo(viewPages)
        }
        
        viewLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.snp_bottomLayoutGuideTop)
            make.height.equalTo(40)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
        viewLabel.textAlignment = .Center
        viewLabel.textColor = UIColor.blackColor()
        viewLabel.backgroundColor = UIColor.whiteColor()
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
        segmentControl.style = .Rainbow
        segmentControl.segmentTextBold = false
        segmentControl.rainbow_colors = [UIColor(hexString: "e72f3c")!, UIColor(hexString: "ffb642")!, UIColor(hexString: "79c7f8")!]
        segmentControl.delegate = self
    }
    
    func initPagesController() {
        pagesController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pagesController.dataSource = self
        pagesController.delegate = self
        
        segmentControl.segments.enumerate().forEach { (index, _) in
            let vc = UIViewController()
            vc.view.backgroundColor = [UIColor(hexString: "e72f3c")!, UIColor(hexString: "ffb642")!, UIColor(hexString: "79c7f8")!][index % 3]
            pages.append(vc)
        }
    }

}

extension ViewController1: WBSegmentControlDelegate {
    func segmentControl(segmentControl: WBSegmentControl, selectIndex newIndex: Int, oldIndex: Int) {
        let targetPages = [pages[newIndex]]
        let direction = ((newIndex > oldIndex) ? UIPageViewControllerNavigationDirection.Forward : UIPageViewControllerNavigationDirection.Reverse)
        pagesController.setViewControllers(targetPages, direction: direction, animated: true, completion: nil)
        
        if let selectedSegment = segmentControl.selectedSegment as? TextSegment {
            viewLabel.text = selectedSegment.otherAttr
        }
    }
}

extension ViewController1: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = pages.indexOf(viewController)!
        return index > 0 ? pages[index - 1] : nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = pages.indexOf(viewController)!
        return index < pages.count - 1 ? pages[index + 1] : nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension ViewController1: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed == false {
            guard let targetPage = previousViewControllers.first else {
                return
            }
            guard let targetIndex = pages.indexOf(targetPage) else {
                return
            }
            segmentControl.selectedIndex = targetIndex
            pageViewController.setViewControllers(previousViewControllers, direction: .Reverse, animated: true, completion: nil)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        guard let targetPage = pendingViewControllers.first else {
            return
        }
        guard let targetIndex = pages.indexOf(targetPage) else {
            return
        }
        segmentControl.selectedIndex = targetIndex
    }
}
