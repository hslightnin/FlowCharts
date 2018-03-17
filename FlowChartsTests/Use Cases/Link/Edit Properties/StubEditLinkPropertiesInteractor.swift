//
//  StubEditLinkPropertiesInteractor.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramGeometry
@testable import FlowCharts

class StubEditLinkPropertiesInteractor: StubInteractor, EditLinkPropertiesInteractorProtocol {
    
    var linkTextRect: Rect?
    var linkCenter = Point()
    
    var lineTypePreset: LineTypePreset = LineTypePreset.curved
    var lineDashPatternPreset = LineDashPatternPreset.solid
}
