//
//  MoveSymbolPanGesturePresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 26/11/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

class PanGestureRecognizerPresenter: FreePresenter, UIGestureRecognizerDelegate {
    
    let presentingView: UIView
    
    var shouldBeRequiredToFailByOtherGestureRecognizers = false
    
    var onBegan: (() -> Void)?
    var onChanged: ((CGVector, UIView) -> Void)?
    var onEnded: (() -> Void)?
    var onCancelled: (() -> Void)?
    
    init(presentingView: UIView) {
        self.presentingView = presentingView
    }
    
    // MARK: - Presented items
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        recognizer.delegate = self
        return recognizer
    }()
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldBeRequiredToFailByOtherGestureRecognizers
    }
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        transition.add(beginning: {
            self.presentingView.addGestureRecognizer(self.panGestureRecognizer)
        })
    }
    
    override func setUpDismission(withIn transition: Transition) {
        transition.add(beginning: {
            self.presentingView.removeGestureRecognizer(self.panGestureRecognizer)
        })
    }
    
    // MARK: - Interactions
    
    func pan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            onBegan?()
            fallthrough
        case .changed:
            let translation = recognizer.translation(in: presentingView)
            let translationVector = CGVector(dx: translation.x, dy: translation.y)
            onChanged?(translationVector, presentingView)
            recognizer.setTranslation(.zero, in: presentingView)
        case .ended:
            onEnded?()
        case .cancelled:
            onCancelled?()
        default:
            break
        }
    }
}
