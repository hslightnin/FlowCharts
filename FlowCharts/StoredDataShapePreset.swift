//
//  StoredDataShapePreset.swift
//  FlowCharts
//
//  Created by alex on 28/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import DiagramGeometry

class StoredDataShapePreset: ShapePreset {
    
    override var shapeType: ShapeType {
        return StoredDataShapeType()
    }
}
