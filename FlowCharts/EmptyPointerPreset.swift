//
//  EmptyPointerPreset.swift
//  FlowCharts
//
//  Created by alex on 14/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry
import DiagramView

class EmptyPointerPreset: PointerPreset {
    
    override var pointerSize: Size {
        return Size(0, 0)
    }
    
    override var pointerType: PointerType {
        return EmptyPointerType()
    }
    
    override var pointerFillPattern: LinkPointerFillPattern {
        return .none
    }
    
    override var thumbnailPointerSize: Size {
        return Size(0, 0)
    }
    
    override var buttonPointerType: PointerType {
        return EllipsisPointerType()
    }
    
    override var buttonPointerSize: Size {
        return Size(2, 2)
    }
}
