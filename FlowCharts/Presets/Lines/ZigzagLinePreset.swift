//
//  ZigzagLinePreset.swift
//  FlowCharts
//
//  Created by alex on 08/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class ZigzagLinePreset: LineTypePreset {
    
    override var lineType: LineType {
        return SmoothedLineType(lineType: ZigzagLineType(shoulder1: 30, shoulder2: 30), cornerRadius: 3)
    }
    
    override var thumbnailLineType: LineType {
        return SmoothedLineType(lineType: ZigzagLineType(shoulder1: 15, shoulder2: 15), cornerRadius: 3)
    }
}
