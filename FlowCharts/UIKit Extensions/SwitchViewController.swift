//
//  SwitchViewController.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 28/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit

class SwitchViewController: UIViewController {

    private var segmentedControl: UISegmentedControl?
    private var currentViewControllerIndex: Int?
    
    let viewControllers: [UIViewController]
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = self.viewControllers.map { $0.title ?? "" }
        self.segmentedControl = UISegmentedControl(items: items)
        self.segmentedControl!.addTarget(self, action: #selector(`switch`(_:)), for: .valueChanged)
        self.segmentedControl!.selectedSegmentIndex = 0
        self.navigationItem.titleView = self.segmentedControl
        
        if self.viewControllers.count > 0 {
            self.switch(toViewControllerAt: 0)
        }
    }
    
    func `switch`(_ sender: UISegmentedControl) {
        self.switch(toViewControllerAt: sender.selectedSegmentIndex)
    }
    
    func `switch`(toViewControllerAt index: Int) {
        
        if let currentViewControllerIndex = self.currentViewControllerIndex {
        
            if index != currentViewControllerIndex {
                
                let oldViewControllerIndex = currentViewControllerIndex
                let newViewControllerIndex = index
                
                let oldViewController = self.viewControllers[oldViewControllerIndex]
                let newViewController = self.viewControllers[newViewControllerIndex]
                
                self.addChildViewController(newViewController)
                self.view.addSubview(newViewController.view)
                newViewController.didMove(toParentViewController: self)
                
                let bounds = contentFrame
                let rectToTheRight = bounds.applying(CGAffineTransform(translationX: bounds.width, y: 0))
                let rectToTheLeft = bounds.applying(CGAffineTransform(translationX: -bounds.width, y: 0))
                
                var oldViewControllerEndFrame: CGRect!
                var newViewControllerStartFrame: CGRect!
                var newViewControllerEndFrame: CGRect!
                
                if newViewControllerIndex > oldViewControllerIndex {
                    oldViewControllerEndFrame = rectToTheLeft
                    newViewControllerStartFrame = rectToTheRight
                    newViewControllerEndFrame = bounds
                } else {
                    oldViewControllerEndFrame = rectToTheRight
                    newViewControllerStartFrame = rectToTheLeft
                    newViewControllerEndFrame = bounds
                }
                
                newViewController.view.frame = newViewControllerStartFrame
                
                UIView.animate(
                    withDuration: 0.25,
                    delay: 0.0,
                    options: [.curveEaseInOut, .beginFromCurrentState],
                    animations: { 
                        newViewController.view.frame = newViewControllerEndFrame
                        oldViewController.view.frame = oldViewControllerEndFrame
                    },
                    completion: { finished in
                        if self.currentViewControllerIndex != oldViewControllerIndex {
                            oldViewController.willMove(toParentViewController: nil)
                            oldViewController.view.removeFromSuperview()
                            oldViewController.removeFromParentViewController()
                        }
                    }
                )
                
                preferredContentSize = newViewController.preferredContentSize
                
                self.currentViewControllerIndex = index
            }
            
        } else {
            
            let newViewControllerIndex = index
            let newViewController = self.viewControllers[newViewControllerIndex]
            self.addChildViewController(newViewController)
            self.view.addSubview(newViewController.view)
            newViewController.didMove(toParentViewController: self)
            
            preferredContentSize = newViewController.preferredContentSize
            
            self.currentViewControllerIndex = index
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let viewControllerIndex = currentViewControllerIndex {
            viewControllers[viewControllerIndex].view.frame = contentFrame
        }
    }
    
    private var contentFrame: CGRect {
        var frame = view.bounds
        if let navigationBar = navigationController?.navigationBar {
            let navigationBarHeight = navigationBar.frame.size.height
            frame.origin.y += navigationBarHeight
            frame.size.height -= navigationBarHeight
        }
        return frame
    }
}
