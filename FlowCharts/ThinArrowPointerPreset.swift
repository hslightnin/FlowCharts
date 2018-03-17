//
//  ThinArrowPointerPreset.swift
//  FlowCharts
//
//  Created by alex on 14/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry
import DiagramView

class ThinArrowPointerPreset: PointerPreset {
    
    override var pointerType: PointerType {
        return ThinArrowPointerType()
    }
    
    override var pointerFillPattern: LinkPointerFillPattern {
        return .none
    }
}
