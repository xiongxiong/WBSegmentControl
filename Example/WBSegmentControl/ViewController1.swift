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
    var pagesController: UIPageViewController!
    var pages: [UIViewController] = []
    
    override func loadView() {
        super.loadView()
        
        initSegmentControl()
        initPagesController()
        
        view.addSubview(segmentControl)
        view.addSubview(viewPages)
        viewPages.addSubview(pagesController.view)
        
        segmentControl.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_topLayoutGuideBottom)
            make.height.equalTo(40)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
        
        viewPages.gestureRecognizers = pagesController.gestureRecognizers
        viewPages.snp_makeConstraints { (make) in
            make.top.equalTo(segmentControl.snp_bottom)
            make.bottom.equalTo(self.snp_bottomLayoutGuideTop)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
        
        pagesController.view.snp_makeConstraints { (make) in
            make.edges.equalTo(viewPages).offset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pagesController.setViewControllers([pages.first!], direction: .Forward, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSegmentControl() {
        segmentControl = WBSegmentControl()
        segmentControl.segments = [
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
