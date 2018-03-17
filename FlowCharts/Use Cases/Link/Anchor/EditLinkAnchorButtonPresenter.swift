//
//  EditLinkAnchorButtonPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 01/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

protocol EditLinkAnchorButtonPresenterInteractionsDelegate: class {
    func editLinkAnchorButtonPresenterDidPressButton(_ presenter: EditLinkAnchorButtonPresenter)
    func editLinkAnchorButtonPresenterWillBeginMovingButton(_ presenter: EditLinkAnchorButtonPresenter)
    func editLinkAnchorButtonPresenter(_ presenter: EditLinkAnchorButtonPresenter, didMoveButtonTo location: CGPoint)
    func editLinkAnchorButtonPresenterDidEndMovingButton(_ presenter: EditLinkAnchorButtonPresenter)
    func editLinkAnchorButtonPresenterDidCancelMovingButton(_ presenter: EditLinkAnchorButtonPresenter)
}

class EditLinkAnchorButtonPresenter: DiagramButtonPresenter {
    
    weak var interactionsDelegate: EditLinkAnchorButtonPresenterInteractionsDelegate?
    
//    var onButtonPressed: (() -> Void)?
    var onPanBegan: (() -> Void)?
    var onPanMoved: ((CGPoint, UIView) -> Void)?
    var onPanEnded: (() -> Void)?
    var onPanCancelled: (() -> Void)?
    
    // MARK: - Properties
    
    var pointerPreset: PointerPreset = .empty {
        didSet {
            updateButtonIcon()
        }
    }
    
    var pointerVector: Vector = Vector(1, 0) {
        didSet {
            updateButtonIcon()
        }
    }
    
    // MARK: - Presented items
    
    override func loadButton() -> DiagramButton {
        let button = DiagramButton()
        button.background = .blue
        button.icon = .pointer(preset: pointerPreset, vector: pointerVector)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(_:))))
        return button
    }
    
    private func updateButtonIcon() {
        button.icon = .pointer(preset: pointerPreset, vector: pointerVector)
    }
    
    // MARK: - Interactions
    
//    func buttonPressed(_ sender: UIButton) {
//        interactionsDelegate?.editLinkAnchorButtonPresenterDidPressButton(self)
//        onButtonPressed?()
//    }
    
    func pan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            button.removeTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            interactionsDelegate?.editLinkAnchorButtonPresenterWillBeginMovingButton(self)
            onPanBegan?()
            fallthrough
        case .changed:
            interactionsDelegate?.editLinkAnchorButtonPresenter(self, didMoveButtonTo: recognizer.location(in: presentingView))
            onPanMoved?(recognizer.location(in: presentingView), presentingView)
        case .ended:
            interactionsDelegate?.editLinkAnchorButtonPresenterDidEndMovingButton(self)
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            onPanEnded?()
        case .cancelled:
            interactionsDelegate?.editLinkAnchorButtonPresenterDidEndMovingButton(self)
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            onPanCancelled?()
        default:
            break
        }
    }
}
