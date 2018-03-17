//
//  StubMoveLinkAnchorInteractor.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramGeometry
@testable import FlowCharts

class StubMoveLinkAnchorInteractor: StubContinuousInteractor, MoveLinkAnchorInteractorProtocol {
    
    var isOriginAnchor = true
    var anchorLocation = Point()
    var anchorVector = Direction.right.vector
    
    func move(to location: Point) {
        anchorLocation = location
    }
    
    var canSave = true
}
