//
//  ResizeSymbolButtonsPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import PresenterKit

class ResizeSymbolControlPresenter: FreePresenter {
    
    enum Activity {
        case chooseMode
        case resize
    }
    
    let presentingView: UIView
    private(set) var activity: Activity?
    private(set) var resizingMode: SymbolResizingMode = .fromOrigin
    
    var onBeginChoosingMode: ((Transition) -> Void)?
    var onEndChoosingMode: ((Transition) -> Void)?
    var onPanBegan: ((SymbolResizingMode) -> Void)?
    var onPanMoved: ((CGPoint, UIView) -> Void)?
    var onPanEnded: (() -> Void)?
    var onPanCancelled: (() -> Void)?
    
    init(presentingView: UIView) {
        self.presentingView = presentingView
    }
    
    // MARK: - Presenter items
    
    private lazy var resizeFromCenterButton: UIButton = {
        let button = DiagramButton()
        button.icon = .resizeFromCenter
        button.background = .blue
        return button
    }()
    
    private lazy var resizeFromOriginButton: UIButton = {
        let button = DiagramButton()
        button.icon = .resizeFromOrigin
        button.background = .blue
        return button
    }()
    
    private var currentModeButton: UIButton {
        switch resizingMode {
        case .fromOrigin:
            return resizeFromOriginButton
        case .fromCenter:
            return resizeFromCenterButton
        }
    }
    
    private var oppositeModeButton: UIButton {
        switch resizingMode {
        case .fromOrigin:
            return resizeFromCenterButton
        case .fromCenter:
            return resizeFromOriginButton
        }
    }
    
    private func addButtonPanGestureRecognizers() {
        resizeFromCenterButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(_:))))
        resizeFromOriginButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(_:))))
    }
    
    private func removeButtonPanGestureRecognizers() {
        resizeFromCenterButton.removeGestureRecognizer(resizeFromCenterButton.gestureRecognizers![0])
        resizeFromOriginButton.removeGestureRecognizer(resizeFromOriginButton.gestureRecognizers![0])
    }
    
    private func addButtonPressActions() {
        resizeFromCenterButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        resizeFromOriginButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    private func removeButtonPressActions() {
        resizeFromCenterButton.removeTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        resizeFromOriginButton.removeTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    private func layout() {
        if activity == .chooseMode {
            let offset = CGFloat(12)
            resizeFromOriginButton.center = CGPoint(
                x: buttonLocation.x - offset,
                y: buttonLocation.y + offset)
            resizeFromCenterButton.center = CGPoint(
                x: buttonLocation.x + offset,
                y: buttonLocation.y - offset)
        } else {
            resizeFromOriginButton.center = buttonLocation
            resizeFromCenterButton.center = buttonLocation
        }
    }
    
    var buttonLocation: CGPoint = .zero {
        didSet {
            layout()
        }
    }
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        transition.add(beginning: {
            self.presentingView.addSubview(self.currentModeButton)
            self.resizeFromOriginButton.alpha = 0.0
            self.resizeFromCenterButton.alpha = 0.0
        }, animation: {
            self.resizeFromOriginButton.alpha = 1.0
            self.resizeFromCenterButton.alpha = 1.0
        }, completion: {
            self.addButtonPressActions()
            self.addButtonPanGestureRecognizers()
        })
    }
    
    override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        transition.add(animation: {
            self.resizeFromOriginButton.alpha = 0.0
            self.resizeFromCenterButton.alpha = 0.0
        }, completion: {
            if self.resizeFromOriginButton.superview != nil {
                self.resizeFromOriginButton.removeFromSuperview()
            }
            if self.resizeFromCenterButton.superview != nil {
                self.resizeFromCenterButton.removeFromSuperview()
            }
        })
    }
    
    // MARK: - Interactions
    
    // MARK: Choosing mode
    
    func buttonPressed(_ sender: UIButton) {
        
//        guard isPresented else {
//            return
//        }
        
        if activity == nil {
            
            let transition = Transition.defaultChangeover()
            onBeginChoosingMode?(transition)
//            delegate?.resizeSymbolButtonPresenter(self, willBeginChoosingModeWith: transition)
            beginChoosingMode(withIn: transition)
            transition.perform()
            
        } else if activity == .chooseMode {
            
            resizingMode = sender == resizeFromOriginButton ? .fromOrigin : .fromCenter
            
            let transition = Transition.defaultChangeover()
            onEndChoosingMode?(transition)
//            delegate?.resizeSymbolButtonPresenter(self, willEndChoosingModeWith: transition)
            endChoosingMode(withIn: transition)
            transition.perform()
        }
    }
    
    func beginChoosingMode(withIn transition: Transition) {
        
        activity = .chooseMode
        
        transition.add(beginning: {
            self.removeButtonPanGestureRecognizers()
            self.presentingView.insertSubview(self.oppositeModeButton, belowSubview: self.currentModeButton)
        }, animation: {
            self.layout()
        })
    }
    
    func endChoosingMode(withIn transition: Transition) {
        
        activity = nil
        
        transition.add(beginning: {
            self.presentingView.bringSubview(toFront: self.currentModeButton)
        }, animation: {
            self.layout()
        }, completion: {
            self.oppositeModeButton.removeFromSuperview()
            self.addButtonPanGestureRecognizers()
        })
    }
    
    // MARK: Resizing
    
    func pan(_ gesture: UIPanGestureRecognizer) {
        
//        guard isPresented else {
//            return
//        }
        
        switch gesture.state {
            
        case .began:
            activity = .resize
            removeButtonPressActions()
            onPanBegan?(resizingMode)
//            delegate?.resizeSymbolButtonPresenterWillBeginMoving(self)
            fallthrough
            
        case .changed:
            let location = gesture.location(in: presentingView)
            onPanMoved?(location, presentingView)
//            delegate?.resizeSymbolButtonPresenter(self, didMoveTo: location)
            
        case .ended:
            onPanEnded?()
//            delegate?.resizeSymbolButtonPresenterDidEndMoving(self)
            addButtonPressActions()
            activity = nil
            
        case .cancelled:
            onPanCancelled?()
//            delegate?.resizeSymbolButtonPresenterDidCancelMoving(self)
            addButtonPressActions()
            activity = nil
            
        default:
            break
        }
    }
}

