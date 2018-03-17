//
//  CircleShapePreset.swift
//  FlowCharts
//
//  Created by alex on 28/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import DiagramGeometry

class CircleShapePreset: ShapePreset {
    
    override var shapeType: ShapeType {
        return EllipsisShapeType()
    }
    
    override var defaultSize: Size {
        return Size(40, 40)
    }
    
    override var requiredWidthToHeightRatio: Double? {
        return 1.0 / 1.0
    }
}
