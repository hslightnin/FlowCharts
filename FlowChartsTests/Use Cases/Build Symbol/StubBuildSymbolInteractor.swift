//
//  StubBuildSymbolInteractor.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry
@testable import FlowCharts

class StubBuildSymbolInteractor: StubInteractor, BuildSymbolInteractorProtocol {
    
    var symbolCenter = Point()
    var symbolFrame = Rect()
    
    var hasCreatedPlaceholder = false
    
    func createPlaceholder() {
        hasCreatedPlaceholder = true
    }
    
    var addedSymbolShapePreset: ShapePreset?
    
    func setShapePreset(_ preset: ShapePreset) {
        addedSymbolShapePreset = preset
    }
    
    var addedSymbolColor: UIColor?
    
    func setColor(_ color: UIColor) {
        addedSymbolColor = color
    }
}
