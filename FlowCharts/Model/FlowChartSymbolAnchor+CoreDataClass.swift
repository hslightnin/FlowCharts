//
//  FlowChartSymbolAnchor+CoreDataClass.swift
//  FlowCharts
//
//  Created by alex on 04/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import CoreData
import DiagramGeometry

class FlowChartSymbolAnchor: FlowChartManagedObject {

    var location: Point {
        get {
            return Point(x, y)
        }
        set {
            (x, y) = (newValue.x, newValue.y)
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
}
