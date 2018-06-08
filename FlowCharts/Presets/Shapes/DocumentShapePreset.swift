//
//  DocumentShapePreset.swift
//  FlowCharts
//
//  Created by alex on 28/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import DiagramGeometry

class DocumentShapePreset: ShapePreset {
    
    override var shapeType: ShapeType {
        return DocumentShapeType()
    }
}
