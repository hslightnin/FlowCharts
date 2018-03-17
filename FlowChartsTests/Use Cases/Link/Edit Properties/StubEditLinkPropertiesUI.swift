//
//  StubEditLinkPropertiesUI.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
@testable import FlowCharts

class StubEditLinkPropertiesUI: EditLinkPropertiesUIProtocol {
    
    var selectedLineTypePreset: LineTypePreset?
    var selectedLineDashPatternPreset: LineDashPatternPreset?
    
    var onSelectedPresetsChanged: ((LineTypePreset, LineDashPatternPreset) -> Void)?
    var onButtonPressed: (() -> Void)?
    var onPopoverShouldDismiss: (() -> Void)?
    
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
    
    weak var layoutDelegate: EditLinkPropertiesUILayoutDelegate!
    
    func layout() {
        
    }
}
