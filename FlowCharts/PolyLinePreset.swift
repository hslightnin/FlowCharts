//
//  PolyLinePreset.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 12/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class PolyLinePreset: LineTypePreset {
    
    override var lineType: LineType {
        return SmoothedLineType(lineType: PolyLineType(minShoulder: 10), cornerRadius: 3)
    }
    
    override var thumbnailLineType: LineType {
        return SmoothedLineType(lineType: PolyLineType(minShoulder: 10), cornerRadius: 3)
    }
}
