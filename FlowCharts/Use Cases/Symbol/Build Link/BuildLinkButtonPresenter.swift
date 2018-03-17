//
//  BuildLinkButtonPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

protocol BuildLinkButtonPresenterInteractionsDelegate: class {
    func buildLinkButtonPresenterWillBeginMovingButton(_ presenter: BuildLinkButtonPresenter)
    func buildLinkButtonPresenter(_ presenter: BuildLinkButtonPresenter, didMoveTo location: CGPoint, in view: UIView)
    func buildLinkButtonPresenterDidEndMovingButton(_ presenter: BuildLinkButtonPresenter)
    func buildLinkButtonPresenterDidCancelMovingButton(_ presenter: BuildLinkButtonPresenter)
}

class BuildLinkButtonPresenter: DiagramButtonPresenter {
    
    weak var interactionsDelegate: BuildLinkButtonPresenterInteractionsDelegate?
    
    var onPanBegan: (() -> Void)?
    var onPanMoved: ((CGPoint, UIView) -> Void)?
    var onPanCancelled: (() -> Void)?
    var onPanEnded: (() -> Void)?
    
    // MARK: - Properties
    
    var direction: Direction = .up {
        didSet {
            switch direction {
            case .up:
                button.icon = UpArrowDiagramButtonIcon()
            case .down:
                button.icon = DownArrowDiagramButtonIcon()
            case .right:
                button.icon = RightArrowDiagramButtonIcon()
            case .left:
                button.icon = LeftArrowDiagramButtonIcon()
            }
        }
    }
    
    // MARK: - Presented items
    
    override func loadButton() -> DiagramButton {
        let button = DiagramButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        button.background = .green
        button.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(_:))))
        return button
    }
    
    // MARK: - Interacions
    
    func pan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            interactionsDelegate?.buildLinkButtonPresenterWillBeginMovingButton(self)
            onPanBegan?()
            fallthrough
        case .changed:
            let view = recognizer.view!.superview!
            let location = recognizer.location(in: view)
            interactionsDelegate?.buildLinkButtonPresenter(self, didMoveTo: location, in: view)
            onPanMoved?(location, view)
        case .ended:
            interactionsDelegate?.buildLinkButtonPresenterDidEndMovingButton(self)
            onPanEnded?()
        case .cancelled:
            interactionsDelegate?.buildLinkButtonPresenterDidCancelMovingButton(self)
            onPanCancelled?()
        default:
            break
        }
    }
}

