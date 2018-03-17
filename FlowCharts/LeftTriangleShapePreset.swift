//
//  LeftTriangleShapePreset.swift
//  FlowCharts
//
//  Created by alex on 28/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import DiagramGeometry

class LeftTriangleShapePreset: ShapePreset {
    
    override var shapeType: ShapeType {
        return LeftTriangleShapeType()
    }
    
    override var defaultSize: Size {
        return Size(46, 46)
    }
    
    override var preferredWidthToHeightRatio: Double? {
        return 1.0 / 1.0
    }
}
