//
//  ButtonPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 26/11/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

class DiagramButtonPresenter: FreePresenter {
    
    let presentingView: UIView
    
    init(presentingView: UIView) {
        self.presentingView = presentingView
        super.init()
    }
    
    var onPressed: (() -> Void)? {
        didSet {
            if oldValue == nil && onPressed != nil {
                button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            } else if oldValue != nil && onPressed == nil {
                button.removeTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            }
        }
    }
    
    // MARK: - Properties
    
    var buttonIcon: DiagramButtonIcon? {
        get {
            return button.icon
        }
        set {
            button.icon = newValue
        }
    }
    
    var buttonBackground: DiagramButtonBackground? {
        get {
            return button.background
        }
        set {
            button.background = newValue
        }
    }
    
    var buttonLocation: CGPoint {
        get {
            return button.center
        }
        set {
            button.center = newValue
        }
    }
    
    var buttonSize: CGSize {
        get {
            return button.frame.size
        }
        set {
            button.frame = CGRect(center: buttonLocation, size: newValue)
            button.layer.cornerRadius = newValue.width / 2
        }
    }
    
    // MARK: - Presenter items
    
    lazy var button: DiagramButton = {
        return self.loadButton()
    }()
    
    func loadButton() -> DiagramButton {
        return DiagramButton()
    }
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        transition.add(beginning: {
            self.presentingView.addSubview(self.button)
            self.button.alpha = 0.0
        }, animation: {
            self.button.alpha = 1
        })
    }
    
    override func setUpDismission(withIn transition: Transition) {
        transition.add(animation: {
            self.button.alpha = 0.0
        }, completion: {
            self.button.removeFromSuperview()
        })
    }
    
    // MARK: Interactions
    
    func buttonPressed(_ sender: DiagramButton) {
        onPressed?()
    }
}
