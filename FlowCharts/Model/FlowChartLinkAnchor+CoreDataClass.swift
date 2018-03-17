//
//  FlowChartLinkAnchor+CoreDataClass.swift
//  FlowCharts
//
//  Created by alex on 04/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import CoreData
import DiagramGeometry

class FlowChartLinkAnchor: FlowChartManagedObject {

    var location: Point {
        get {
            return Point(x, y)
        }
        set {
            (x, y) = (newValue.x, newValue.y)
        }
    }
    
    var pointerPreset: PointerPreset {
        get {
            return PointerPreset.preset(withId: Int(pointerPresetId))
        }
        set {
            pointerPresetId = Int32(PointerPreset.id(forPreset: newValue))
        }
    }
    
    var direction: Direction {
        get {
            return Direction(rawValue: Int(directionValue))!
        }
        set {
            directionValue = Int32(newValue.rawValue)
        }
    }
    
    var link: FlowChartLink {
        return originLink ?? endingLink!
    }
    
    var isOrigin: Bool {
        return originLink != nil
    }
    
    var isEnding: Bool {
        return !isOrigin
    }
    
    var oppositeAnchor: FlowChartLinkAnchor {
        return self === link.origin ? link.ending : link.origin
    }
}
