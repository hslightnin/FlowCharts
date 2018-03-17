//
//  CurvedLinePreset.swift
//  FlowCharts
//
//  Created by alex on 08/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class CurvedLinePreset: LineTypePreset {
    
    override var lineType: LineType {
        return CurvedLineType()
    }
    
    override var thumbnailLineType: LineType {
        return CurvedLineType()
    }
}
