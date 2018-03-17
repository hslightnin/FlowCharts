//
//  StrokedCirclePointerPreset.swift
//  FlowCharts
//
//  Created by alex on 14/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry
import DiagramView

class StrokedCirclePointerPreset: PointerPreset {
    
    override var pointerType: PointerType {
        return EllipsisPointerType()
    }
    
    override var pointerFillPattern: LinkPointerFillPattern {
        return .fillWithBackgroundColor
    }
    
    override var pointerSize: Size {
        return Size(6, 6)
    }
    
    override var thumbnailPointerSize: Size {
        return Size(10, 10)
    }
    
    override var buttonArrowLength: Double {
        return 0
    }
    
    override var buttonPointerSize: Size {
        return Size(8, 8)
    }
}
