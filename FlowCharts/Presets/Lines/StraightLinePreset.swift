//
//  StraightLinePreset.swift
//  FlowCharts
//
//  Created by alex on 08/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class StraightLinePreset: LineTypePreset {
    
    override var lineType: LineType {
        return StraightLineType()
    }
    
    override var thumbnailLineType: LineType {
        return StraightLineType()
    }
}
