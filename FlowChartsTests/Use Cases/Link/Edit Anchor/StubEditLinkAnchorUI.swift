//
//  StubEditLinkAnchorUI.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramGeometry
@testable import FlowCharts

class StubEditLinkAnchorUI: EditLinkAnchorUIProtocol {
    
    var pointerVector = Direction.right.vector
    var selectedPointerPreset: PointerPreset?
    
    var onButtonPressed: (() -> Void)?
    var onSelectedPointerPresetChanged: ((PointerPreset) -> Void)?
    var onPopoverShouldDismiss: (() -> Void)?
    
    var onPanBegan: (() -> Void)?
    var onPanMoved: ((CGPoint, UIView) -> Void)?
    var onPanEnded: (() -> Void)?
    var onPanCancelled: (() -> Void)?
    
    var isButtonPresented = false
    
    func prepareForButtonPresentation(withIn transition: Transition) {
        transition.addBeginning {
            self.isButtonPresented = true
        }
    }
    
    func prepareForButtonDismission(withIn transition: Transition) {
        transition.addBeginning {
            self.isButtonPresented = false
        }
    }
    
    var isPropertiesPopoverPresented = false
    
    func preparePropertiesPopoverPresentationTransition() -> Transition {
        let transition = Transition.instant()
        transition.addBeginning {
            self.isPropertiesPopoverPresented = true
        }
        return transition
    }
    
    func preparePropertiesPopoverDismissionTransition() -> Transition {
        let transition = Transition.instant()
        transition.addBeginning {
            self.isPropertiesPopoverPresented = false
        }
        return transition
    }
    
    let presentingView = UIView()
    
    weak var layoutDelegate: EditLinkAnchorLayoutDelegate!
    
    func layout() {
        
    }
}
