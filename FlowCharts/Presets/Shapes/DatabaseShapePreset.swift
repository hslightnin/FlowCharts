//
//  DatabaseShapePreset.swift
//  FlowCharts
//
//  Created by alex on 28/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import DiagramGeometry

class DatabaseShapePreset: ShapePreset {
    
    override var shapeType: ShapeType {
        return DatabaseShapeType()
    }
    
    override var defaultSize: Size {
        return Size(60, 40)
    }
    
    override var preferredWidthToHeightRatio: Double? {
        return 1.0 / 1.0
    }
}
