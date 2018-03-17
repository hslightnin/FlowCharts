//
//  StubEditSymbolPropertiesUI.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation
import PresenterKit
@testable import FlowCharts

class StubEditSymbolPropertiesUI: EditSymbolPropertiesUIProtocol {
    
    var selectedShapePreset: ShapePreset?
    var selectedColor: UIColor?
    
    var onButtonPressed: (() -> Void)?
    var onShapePresetSelected: ((ShapePreset) -> Void)?
    var onColorSelected: ((UIColor) -> Void)?
    var onSelectionEnded: (() -> Void)?
    
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
    
    var presentingView = UIView()
    var buttonLocation = CGPoint.zero
    
    weak var layoutDelegate: EditSymbolPropertiesUILayoutDelegate!
    
    func layout() {
        buttonLocation = layoutDelegate.buttonLocation(in: presentingView)
    }
}
