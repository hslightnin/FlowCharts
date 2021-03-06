//
//  PlaceholderShapePreset.swift
//  FlowCharts
//
//  Created by alex on 28/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import DiagramGeometry

class PlaceholderShapePreset: ShapePreset {
    
    override var shapeType: ShapeType {
        return RoundedCornerRectShapeType(cornerRadius: 10)
    }
}
