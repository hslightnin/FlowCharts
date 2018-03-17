//
//  StubBuildSymbolUI.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
@testable import FlowCharts

class StubBuildSymbolUI: BuildSymbolUIProtocol {
    
    var onButtonPressed: (() -> Void)?
    var onPresetsSelected: ((ShapePreset, UIColor) -> Void)?
    var onPresetsSelectionCancelled: (() -> Void)?
    
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
    
    var isPresetsPopoverPresented = false
    
    func preparePresetsPopoverPresentationTransition() -> Transition {
        let transition = Transition.instant()
        transition.addBeginning {
            self.isPresetsPopoverPresented = true
        }
        return transition
    }
    
    func preparePresetsPopoverDismissionTransition() -> Transition {
        let transition = Transition.instant()
        transition.addBeginning {
            self.isPresetsPopoverPresented = false
        }
        return transition
    }
    
    weak var layoutDelegate: BuildSymbolUILayoutDelegate!
    
    func layout() {
        
    }
}
