//
//  StrokedTrianglePointerPreset.swift
//  FlowCharts
//
//  Created by alex on 14/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry
import DiagramView

class StrokedTrianglePointerPreset: PointerPreset {
    
    override var pointerType: PointerType {
        return TrianglePointerType()
    }
    
    override var pointerFillPattern: LinkPointerFillPattern {
        return .fillWithBackgroundColor
    }
}
