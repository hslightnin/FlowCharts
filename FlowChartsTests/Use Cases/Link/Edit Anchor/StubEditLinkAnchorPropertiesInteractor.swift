//
//  StubEditLinkAnchorPropertiesInteractor.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramGeometry
@testable import FlowCharts

class StubEditLinkAnchorPropertiesInteractor: StubInteractor, EditLinkAnchorPropertiesInteractorProtocol {
    
    var pointerVector = Vector(1, 0)
    var pointerPreset: PointerPreset = PointerPreset.empty
}
