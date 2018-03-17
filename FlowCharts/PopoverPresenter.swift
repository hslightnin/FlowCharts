//
//  PopoverPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 26/11/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

class PopoverPresenter: FixedPresenter, UIPopoverPresentationControllerDelegate {
    
    let presentingController: UIViewController
    
    var sourceView: UIView
    var sourceRect: CGRect
    var preferredArrowDirections: UIPopoverArrowDirection
    
    var onShouldDismiss: (() -> Void)?
    
    init(presentingController: UIViewController) {
        self.presentingController = presentingController
        self.sourceView = presentingController.view
        self.sourceRect = presentingController.view.bounds
        self.preferredArrowDirections = .any
    }
    
    // MARK: - Presented items
    
    private lazy var contentViewController: UIViewController = {
        return self.loadContentViewController()
    }()
    
    func loadContentViewController() -> UIViewController {
        fatalError("Must be implemented in subclass")
    }
    
    // MARK: - Lifecycle
    
    override func createPresentationTransition() -> Transition {
        
        let screenBounds = UIScreen.main.bounds
        let popoverSize = self.contentViewController.preferredContentSize
        let screenView: UIView? = nil
        let sourceRectOnScreen = self.sourceView.convert(self.sourceRect, to: screenView)
        let arrowHeight = CGFloat(13)
        
        var permittedArrowDirections = self.preferredArrowDirections
        
        switch self.preferredArrowDirections {
        case .left:
            if screenBounds.maxX < sourceRectOnScreen.maxX + (popoverSize.width + arrowHeight) {
                permittedArrowDirections = [.up, .down]
            }
            
        case .right:
            if screenBounds.minX > sourceRectOnScreen.minX - (popoverSize.width + arrowHeight) {
                permittedArrowDirections = [.up, .down]
            }
            
        case .up:
            if screenBounds.maxY < sourceRectOnScreen.maxY + (popoverSize.height + arrowHeight) {
                permittedArrowDirections = [.left, .right]
            }
            
        case .down:
            if screenBounds.minY > sourceRectOnScreen.minY - (popoverSize.height + arrowHeight) {
                permittedArrowDirections = [.left, .right]
            }
            
        default:
            break
        }
        
        self.contentViewController.modalPresentationStyle = .popover
        let popoverPresentationController = self.contentViewController.popoverPresentationController!
        popoverPresentationController.permittedArrowDirections = permittedArrowDirections
        popoverPresentationController.sourceView = self.sourceView
        popoverPresentationController.sourceRect = self.sourceRect
        popoverPresentationController.backgroundColor = .white
        popoverPresentationController.delegate = self
        
        return ViewControllerPresentationTransition(
            presentingViewController: presentingController,
            presentedViewController: contentViewController)
    }
    
    override func createDismissionTransition() -> Transition {
        return ViewControllerDismissionTransition(
            viewController: contentViewController)
    }
    
    // MARK: - Interactions
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        onShouldDismiss?()
        return false
    }
}
