//
//  StubResizeSymbolInteractor.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation

import PresenterKit
import DiagramGeometry
@testable import FlowCharts

class StubResizeSymbolInteractor: StubContinuousInteractor, ResizeSymbolInteractorProtocol {
    
    var mode: SymbolResizingMode = .fromOrigin
    
    var rightBottomCorner = Point()
    
    func moveRightBottomCorner(to location: Point) {
        rightBottomCorner = location
    }
}
