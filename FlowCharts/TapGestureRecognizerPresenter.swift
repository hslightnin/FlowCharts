//
//  EditSymbolTextCancelPanGestureRecognizerPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 13/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

protocol TapGestureRecognizerPresenterInteractionsDelegate: class {
    func tapGestureRecognizerPresenterDidRecognizeTap(_ presenter: TapGestureRecognizerPresenter)
}

class TapGestureRecognizerPresenter: FreePresenter, UIGestureRecognizerDelegate {
    
    let presentingView: UIView
    let numberOfTapsRequired: Int
    var shouldBeRequiredToFailByOthers = false
    
    weak var interactionsDelegate: TapGestureRecognizerPresenterInteractionsDelegate?
    var onRecognized: (() -> Void)?
    
    init(presentingView: UIView, numberOfTapsRequired: Int = 1) {
        self.presentingView = presentingView
        self.numberOfTapsRequired = numberOfTapsRequired
    }
    
    // MARK: - Presenter items
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        recognizer.numberOfTapsRequired = self.numberOfTapsRequired
        recognizer.delegate = self
        return recognizer
    }()
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        transition.add(beginning: {
            self.presentingView.addGestureRecognizer(self.tapGestureRecognizer)
        })
    }
    
    override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        transition.add(beginning: {
            self.presentingView.removeGestureRecognizer(self.tapGestureRecognizer)
        })
    }
    
    // MARK: - Interactions
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldBeRequiredToFailByOthers
    }
    
    func tap(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .recognized {
            interactionsDelegate?.tapGestureRecognizerPresenterDidRecognizeTap(self)
            onRecognized?()
        }
    }
}
